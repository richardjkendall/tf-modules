/*
title: basic-cicd-ecs-pipeline
desc: Builds a codepipeline and codebuild job attached to an ECS service to manage continious deployment as the source code in a github repository changes
partners: ecs-service, github-status-updater
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "gh_secret" {
  name = var.gh_secret_sm_param_name
}

data "aws_ssm_parameter" "gh_token" {
  name = var.gh_token_sm_param_name
}

resource "aws_s3_bucket" "build_bucket" {
  acl           = "private"
  force_destroy = true

  tags = {
    Name    = "ECS pipeline build bucket"
    Cluster = var.cluster_name
    Service = var.service_name
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
      "${aws_s3_bucket.build_bucket.arn}",
      "${aws_s3_bucket.build_bucket.arn}/*"
    ]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = ["*"]
  }

}

data "aws_iam_policy_document" "code_pipeline_policy_document" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.build_bucket.arn}",
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

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "iam:PassRole"
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
  name        = "basic-cicd-build-${var.cluster_name}-${var.service_name}-cb-attach"
  roles       = [aws_iam_role.code_build_role.name]
  policy_arn  = aws_iam_policy.code_build_policy.arn
}

resource "aws_iam_policy_attachment" "attach_cp_policy_to_role" {
  name        = "basic-cicd-build-${var.cluster_name}-${var.service_name}-cp-attach"
  roles       = [aws_iam_role.code_pipeline_role.name]
  policy_arn  = aws_iam_policy.code_pipeline_policy.arn
}

resource "aws_codebuild_project" "codebuild_project" {
  name          = "basic-cicd-build-${var.gh_repo}-${var.gh_branch}-${var.cluster_name}-${var.service_name}"
  description   = "build ecs image for service ${var.service_name} on cluster ${var.cluster_name} from repo ${var.gh_repo} using branch ${var.gh_branch}"
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
    image                       = "aws/codebuild/docker:17.09.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.image_repo
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "CLUSTER_NAME"
      value = var.cluster_name
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "random_uuid" "notify_name" { }

resource "aws_codestarnotifications_notification_rule" "notifications" {
  count = var.send_notifications == true ? 1 : 0

  detail_type     = "FULL"
  event_type_ids  = var.notifications_to_send
  name            = random_uuid.notify_name.result
  resource        = aws_codepipeline.buildpipeline.arn

  target {
    address = var.sns_topic_for_notifications
  }
}

resource "aws_codepipeline" "buildpipeline" {
  name        = "basic-cicd-pipeline-${var.gh_repo}-${var.gh_branch}-${var.cluster_name}-${var.service_name}"
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
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = [var.gh_branch]
      output_artifacts = ["BuildOutput"]
      version          = "1"

      configuration = {
        ProjectName = "basic-cicd-build-${var.gh_repo}-${var.gh_branch}-${var.cluster_name}-${var.service_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildOutput"]
      version         = "1"

      configuration = {
        ClusterName = var.cluster_name
        ServiceName = var.service_name
        FileName    = "deploy.json"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "webhook" {
  name            = "github-${var.gh_repo}-${var.gh_branch}-${var.cluster_name}-${var.service_name}"
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