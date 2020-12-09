/*
title: basic-cicd-s3-to-s3-pipeline
desc: Builds a codepipeline and codebuild job attached to an S3 backed cloudfront distribution to deploy changes as the source code changes.  Uses an S3 bucket as a source.
partners: static-site
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "target_bucket" {
  bucket = var.s3_bucket
}

resource "aws_s3_bucket" "build_bucket" {
  acl = "private"

  tags = {
    Name = "Static site build bucket"
    Site = var.site_name
  }

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

  dynamic "logging" {
    for_each = var.access_log_bucket != "" ? [ "blah" ] : []

    content {
      target_bucket = var.access_log_bucket
      target_prefix = var.access_log_prefix
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

data "aws_iam_policy_document" "code_build_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "code_pipeline_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["codepipeline.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "code_build_policy_document" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
    ]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      data.aws_s3_bucket.target_bucket.arn,
      "${data.aws_s3_bucket.target_bucket.arn}/*",
      aws_s3_bucket.build_bucket.arn,
      "${aws_s3_bucket.build_bucket.arn}/*",
      "arn:aws:s3:::${var.source_s3_bucket}",
      "arn:aws:s3:::${var.source_s3_bucket}/*",
    ]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["cloudfront:CreateInvalidation"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "code_pipeline_policy_document" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      aws_s3_bucket.build_bucket.arn,
      "${aws_s3_bucket.build_bucket.arn}/*"
    ]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning"
    ]
    resources = ["*"]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "code_build_policy" {
  policy = data.aws_iam_policy_document.code_build_policy_document.json
}

resource "aws_iam_policy" "code_pipeline_policy" {
  policy = data.aws_iam_policy_document.code_pipeline_policy_document.json
}

resource "aws_iam_role" "code_build_role" {
  assume_role_policy = data.aws_iam_policy_document.code_build_assume_policy.json
}

resource "aws_iam_role" "code_pipeline_role" {
  assume_role_policy = data.aws_iam_policy_document.code_pipeline_assume_policy.json
}

resource "aws_iam_policy_attachment" "attach_cb_policy_to_role" {
  name        = "basic-cicd-build-${var.site_name}-${var.cf_distribution}-cb-attach"
  roles       = [aws_iam_role.code_build_role.name]
  policy_arn  = aws_iam_policy.code_build_policy.arn
}

resource "aws_iam_role_policy_attachment" "cb_role_user_policies" {
  count       = length(var.build_role_policies)

  role        = aws_iam_role.code_build_role.name
  policy_arn  = element(var.build_role_policies, count.index)
}

resource "aws_iam_policy_attachment" "attach_cp_policy_to_role" {
  name        = "basic-cicd-build-${var.site_name}-${var.cf_distribution}-cp-attach"
  roles       = [aws_iam_role.code_pipeline_role.name]
  policy_arn  = aws_iam_policy.code_pipeline_policy.arn
}

resource "aws_codebuild_project" "codebuild_project" {
  name          = "basic-cicd-build-s3-${var.source_s3_prefix}-${var.cf_distribution}"
  description   = "build site ${var.site_name} for CF dist ${var.cf_distribution} from s3 bucket ${var.source_s3_bucket} using prefix ${var.source_s3_prefix}"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.code_build_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.allow_root

    environment_variable {
      name  = "TARGET_BUCKET"
      value = var.s3_bucket
    }

    environment_variable {
      name  = "INVALIDATE"
      value = var.cf_invalidate
    }

    environment_variable {
      name  = "DISTRIBUTION_ID"
      value = var.cf_distribution
    }

    dynamic "environment_variable" {
      for_each = var.build_environment

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codepipeline" "buildpipeline" {
  name        = "basic-cicd-pipeline-${var.source_s3_prefix}-${var.cf_distribution}"
  role_arn    = aws_iam_role.code_pipeline_role.arn

  artifact_store {
    location  = aws_s3_bucket.build_bucket.bucket
    type      = "S3"
  }

  stage {
    name = "Source"

    action {
      name              = "Source"
      category          = "Source"
      owner             = "AWS"
      provider          = "S3"
      version           = "1"
      output_artifacts  = ["SrcOut"]

      configuration = {
        S3Bucket              = var.source_s3_bucket
        S3ObjectKey           = "${var.source_s3_prefix}/latest.zip"
        PollForSourceChanges  = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SrcOut"]
      version         = "1"

      configuration = {
        ProjectName = "basic-cicd-build-s3-${var.source_s3_prefix}-${var.cf_distribution}"
      }
    }
  }
}

/* need a clouwatch event to trigger the pipeline on s3 upload */

data "aws_iam_policy_document" "cw_event_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cw_event_policy" {
  statement {
    effect    = "Allow"
    actions   = [
      "codepipeline:StartPipelineExecution",
      "codepipeline:GetPipelineState",
      "codepipeline:GetPipeline"
    ]
    resources = [
      aws_codepipeline.buildpipeline.arn
    ]
  }
}

resource "aws_iam_role" "cw_event_role" {
  assume_role_policy = data.aws_iam_policy_document.cw_event_assume_policy.json
}

resource "aws_iam_policy" "cw_event_policy" {
  policy = data.aws_iam_policy_document.cw_event_policy.json
}

resource "aws_iam_policy_attachment" "cw_event_policy" {
  name        = "basic-cicd-cloudwatch-${var.site_name}-${var.cf_distribution}-cp-attach"
  roles       = [aws_iam_role.cw_event_role.name]
  policy_arn  = aws_iam_policy.cw_event_policy.arn
}

resource "aws_cloudwatch_event_rule" "trigger" {
  name_prefix   = "cicd-trigger"
  event_pattern = <<PATTERN
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": [
      "CopyObject",
      "CompleteMultipartUpload",
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": ["${var.source_s3_bucket}"],
      "key": ["${var.source_s3_prefix}/latest.zip"]
    }
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "trigger" {
  arn       = aws_codepipeline.buildpipeline.arn
  rule      = aws_cloudwatch_event_rule.trigger.name
  role_arn  = aws_iam_role.cw_event_role.arn
}