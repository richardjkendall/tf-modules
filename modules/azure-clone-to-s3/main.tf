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