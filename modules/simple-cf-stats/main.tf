/*
title: simple-cf-stats
desc: Deploys a simple service based on webalizer to produce stats for AWS Cloudfront distributions.  The stats are rebuilt every 6 hours.
depends: ecs-service
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "dynamodb_access_policy" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = ["dynamodb:GetItem"]
    resources = ["arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.users_table}"]
  }
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  policy = data.aws_iam_policy_document.dynamodb_access_policy.json
}

data "aws_iam_policy_document" "access_s3_logs_policy_document" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.log_bucket}"
    ]
  }

  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.log_bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "access_s3_logs_policy_document" {
  policy = data.aws_iam_policy_document.access_s3_logs_policy_document.json
}

module "service" {
  source = "../ecs-service"

  aws_region                    = var.aws_region
  cluster_name                  = var.cluster_name
  service_name                  = var.service_name
  service_registry_id           = var.service_registry_id
  service_registry_service_name = var.service_registry_service_name

  task_name          = "proxy"
  image              = "not used"
  cpu                = 256
  memory             = 384
  network_mode       = "bridge"
  number_of_tasks    = 1

  port_mappings = [
    {
      containerPort = 80
      hostPort = 0
      protocol = "tcp"
    }
  ]

  task_def_override = templatefile("${path.module}/tasks.json", {
    region           = var.aws_region
    cluster          = var.cluster_name
    service          = var.service_name
    table            = var.users_table
    realm            = var.auth_realm
    folder           = var.cache_dir
    duration         = var.cache_duration
    log_bucket       = var.log_bucket
    log_prefix       = var.log_prefix
    hostname         = var.hostname
    filter           = jsonencode(jsonencode(var.filter))
  })

  task_role_policies = [
    aws_iam_policy.access_s3_logs_policy_document.id,
    aws_iam_policy.dynamodb_access_policy.arn
  ]
}

data "aws_iam_policy_document" "ecs_access_policy" {
  statement {
    sid = "1"
    effect = "Allow"

    actions = [
      "ecs:UpdateService"
    ]

    resources = [
      "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:service/${var.cluster_name}/${var.service_name}"
    ]
  }
}

resource "aws_iam_policy" "ecs_access_policy" {
  policy = data.aws_iam_policy_document.ecs_access_policy.json
}

module "lambda" {
  source = "../lambda-function"

  aws_region        = var.aws_region
  function_name     = "Stats-Updater-${var.cluster_name}-${var.service_name}"
  function_handler  = "lambda.handler"
  runtime           = "python3.8"
  timeout           = 20
  code_repository   = "https://github.com/richardjkendall/force-ecs-redeploy.git"
  
  execution_role_policies = [
    aws_iam_policy.ecs_access_policy.arn
  ]

  environment_variables = {
    CLUSTER = var.cluster_name,
    SERVICE = var.service_name
  }
}

module "schedule" {
  source = "../lambda-schedule"

  depends_on = [module.lambda]

  aws_region          = var.aws_region
  function_name       = module.lambda.function_name
  schedule_expression = "rate(6 hours)"
}