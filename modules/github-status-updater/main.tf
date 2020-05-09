/*
title: github-status-updater
desc: Creates an SNS topic which you can attach to codepipeline instances to send notifications.  Notifications are converted to github status labels and posted to github.
partners: basic-cicd-ecs-pipeline, basic-cicd-s3-pipeline
depends: lambda-function
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

locals {
  kms_id = var.encrypt ? aws_kms_key.kms_key.0.key_id : null
}

resource "aws_sns_topic" "cp_sns_topic" {
  name_prefix       = "cp-notifications-topic"
}

resource "aws_sns_topic_policy" "cp_sns_topic" {
  arn    = aws_sns_topic.cp_sns_topic.arn
  policy = data.aws_iam_policy_document.cp_sns_topic.json
}

data "aws_iam_policy_document" "cp_sns_topic" {
  statement {
    sid = "__default_statement_ID"

    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.cp_sns_topic.arn,
    ]
  }

  statement {
    sid = "AWSCodeStarNotifications_publish"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["codestar-notifications.amazonaws.com"]
    }
    actions = [
      "SNS:Publish"
    ]
    resources = [
      aws_sns_topic.cp_sns_topic.arn
    ]
  }
}

data "aws_iam_policy_document" "kms_key" {
  count = var.encrypt ? 1 : 0

  statement {
    sid = "AllowAccountAccess"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    } 
  }
  
  statement {
    sid = "SNSallowedtousekey"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "Lambdaallowedtousekey"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_kms_key" "kms_key" {
  count = var.encrypt ? 1 : 0

  description = "key used by github status updater"
  policy      = data.aws_iam_policy_document.kms_key.0.json
}

resource "aws_sqs_queue" "cp_notify_sqs_queue" {
  name_prefix       = "cp-notifications-raw-queue"

  /* had to add this because codepipeline API is eventually consistent... */
  delay_seconds     = var.delay_seconds

  kms_master_key_id = local.kms_id
}

data "aws_iam_policy_document" "cp_notify_sqs_queue" {
  statement {
    sid = "1"

    effect = "Allow"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = ["SQS:SendMessage"]

    resources = [
      aws_sqs_queue.cp_notify_sqs_queue.arn
    ] 

    condition {
      test = "ArnEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_sns_topic.cp_sns_topic.arn
      ]
    }
  }
}

resource "aws_sqs_queue_policy" "cp_notify_sqs_queue" {
  queue_url = aws_sqs_queue.cp_notify_sqs_queue.id
  policy    = data.aws_iam_policy_document.cp_notify_sqs_queue.json
}

data "aws_iam_policy_document" "enricher_policy" {
  statement {
    sid = "1"
    
    effect = "Allow"

    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.enriched_sqs_queue.arn
    ]
  }

  statement {
    sid = "2"

    effect = "Allow"

    actions = [
      "codepipeline:GetPipeline",
      "codepipeline:GetPipelineExecution"
    ]

    resources = [
      "arn:aws:codepipeline:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }

  statement {
    sid       = "3"
    effect    = "Allow"

    resources = [
      aws_sqs_queue.cp_notify_sqs_queue.arn
    ]

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]
  }
}

resource "aws_iam_policy" "enricher_policy" {
  policy = data.aws_iam_policy_document.enricher_policy.json
}

module "enricher" {
  source = "../lambda-function"

  aws_region        = var.aws_region
  function_name     = "codepipeline-enricher"
  function_handler  = "lambda.entry"
  runtime           = "python3.7"
  timeout           = 30
  memory            = 128
  code_repository   = "https://github.com/richardjkendall/codepipeline-enricher.git"
  
  execution_role_policies = [
    aws_iam_policy.enricher_policy.arn
  ]

  environment_variables = {
    region  = var.aws_region
    queue   = aws_sqs_queue.enriched_sqs_queue.name
  }
}

resource "aws_sqs_queue" "enriched_sqs_queue" {
  name_prefix       = "cp-notifications-enriched-queue"

  kms_master_key_id = local.kms_id
}

data "aws_iam_policy_document" "poster_policy" {
  statement {
    sid = "1"
    
    effect = "Allow"

    actions = [
      "ssm:GetParameter"
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.gh_access_token_parameter}"
    ]
  }

  statement {
    sid       = "2"
    effect    = "Allow"

    resources = [
      aws_sqs_queue.enriched_sqs_queue.arn
    ]

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]
  }
}

resource "aws_iam_policy" "poster_policy" {
  policy = data.aws_iam_policy_document.poster_policy.json
}

module "poster" {
  source = "../lambda-function"

  aws_region        = var.aws_region
  function_name     = "codepipeline-gh-poster"
  function_handler  = "lambda.entry"
  runtime           = "python3.7"
  timeout           = 30
  memory            = 128
  code_repository   = "https://github.com/richardjkendall/codepipeline-github-poster.git"
  
  execution_role_policies = [
    aws_iam_policy.poster_policy.arn
  ]

  environment_variables = {
    region          = var.aws_region
    gh_username     = var.gh_username
    gh_access_token = var.gh_access_token_parameter
  }
}

resource "aws_sns_topic_subscription" "cp_notify_sns_to_sqs" {
  topic_arn = aws_sns_topic.cp_sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.cp_notify_sqs_queue.arn
}

resource "aws_lambda_event_source_mapping" "cp_notify_to_lambda" {
  event_source_arn = aws_sqs_queue.cp_notify_sqs_queue.arn
  function_name    = module.enricher.function_name
}

resource "aws_lambda_event_source_mapping" "enriched_to_lambda" {
  event_source_arn = aws_sqs_queue.enriched_sqs_queue.arn
  function_name    = module.poster.function_name
}