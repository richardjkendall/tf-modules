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

data "aws_ssm_parameter" "gh_secret" {
  name = var.gh_secret_sm_param_name
}

data "aws_ssm_parameter" "gh_token" {
  name = var.gh_token_sm_param_name
}

resource "aws_s3_bucket" "build_bucket" {
  acl = "private"

  tags = {
    Name = "Static site build bucket"
    Site = var.site_name
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
      "${aws_s3_bucket.build_bucket.arn}/*"
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

resource "aws_iam_policy_attachment" "attach_cp_policy_to_role" {
  name        = "basic-cicd-build-${var.site_name}-${var.cf_distribution}-cp-attach"
  roles       = [aws_iam_role.code_pipeline_role.name]
  policy_arn  = aws_iam_policy.code_pipeline_policy.arn
}

resource "aws_codebuild_project" "codebuild_project" {
  name          = "basic-cicd-build-${var.gh_repo}-${var.gh_branch}-${var.cf_distribution}"
  description   = "build site ${var.site_name} for CF dist ${var.cf_distribution} from repo ${var.gh_repo} using branch ${var.gh_branch}"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.code_build_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
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
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_codepipeline" "buildpipeline" {
  name        = "basic-cicd-pipeline-${var.gh_repo}-${var.gh_branch}-${var.cf_distribution}"
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
      owner             = "ThirdParty"
      provider          = "GitHub"
      version           = "1"
      output_artifacts  = [var.gh_branch]

      configuration = {
        Owner                 = var.gh_username
        Repo                  = var.gh_repo
        Branch                = var.gh_branch
        OAuthToken            = data.aws_ssm_parameter.gh_token.value
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
      input_artifacts = [var.gh_branch]
      version         = "1"

      configuration = {
        ProjectName = "basic-cicd-build-${var.gh_repo}-${var.gh_branch}-${var.cf_distribution}"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "webhook" {
  name            = "github-${var.gh_repo}-${var.gh_branch}-${var.cf_distribution}"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.buildpipeline.name

  authentication_configuration {
    secret_token = data.aws_ssm_parameter.gh_secret.value
  }

  filter {
    json_path     = "$.ref"
    match_equals  = "refs/heads/{Branch}"
  }
}