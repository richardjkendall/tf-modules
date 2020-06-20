/*
title: azure-clone-to-s3
desc: Creates an API which can be called by Azure to clone an Azure Devops repo into an S3 bucket so it can be used by tools like CodePipeline
depends: api-lambda
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "build_bucket" {
  acl = "private"

  bucket_prefix = "azure-cp-build"

  versioning {
    enabled = true
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.encrypt_buckets == true ? [ "blah" ] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_build_bucket_pub_access" {
  bucket = aws_s3_bucket.build_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "trail_bucket" {
  bucket_prefix = "cloudtrail"
  force_destroy = true

  dynamic "server_side_encryption_configuration" {
    for_each = var.encrypt_buckets == true ? [ "blah" ] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
  }
}

data "aws_iam_policy_document" "trail_bucket_policy" {
  statement {
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.trail_bucket.bucket}"
    ]

    actions = [
      "s3:GetBucketAcl"
    ]

    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    effect = "Allow"
    
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.trail_bucket.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
    
    actions = [
      "s3:PutObject"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "trail_bucket_policy" {
  bucket = aws_s3_bucket.trail_bucket.id
  policy = data.aws_iam_policy_document.trail_bucket_policy.json
}

resource "aws_s3_bucket_public_access_block" "block_trail_bucket_pub_access" {
  bucket = aws_s3_bucket.trail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudtrail" "s3_events_trail" {
  name                          = "azure-cp-s3-trail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = false

  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = false

    data_resource {
      type = "AWS::S3::Object"

      values = ["${aws_s3_bucket.build_bucket.arn}/"]
    }
  }
}

data "aws_iam_policy_document" "api_policy" {
  statement {
    sid = "1"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.api_password_ssm_param}",
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.azure_devops_git_token_ssm_param}"
    ]
  }

  statement {
    sid = "2"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.build_bucket.arn,
      "${aws_s3_bucket.build_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "api_policy" {
  policy = data.aws_iam_policy_document.api_policy.json
}

module "api" {
  source = "../api-lambda"

  aws_region        = var.aws_region
  api_name          = "azure-devops-to-s3"
  function_name     = "azure-devops-to-s3"
  handler           = "main.lambda_handler"
  runtime           = "python3.7"
  timeout           = 300
  memory            = 256
  code_repository   = "https://github.com/richardjkendall/azure-devops-cp-starter.git"
  http_method       = "POST"
  stage_name        = "prod"

  environment_variables = {
    API_USERNAME    = var.api_username,
    PASS_PARAM      = var.api_password_ssm_param,
    AD_USERNAME     = var.azure_devops_git_username,
    AD_TOKEN_PARAM  = var.azure_devops_git_token_ssm_param,
    S3_BUCKET       = aws_s3_bucket.build_bucket.id
  }

  execution_role_policies = [
    aws_iam_policy.api_policy.arn
  ]
}