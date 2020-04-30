/*
title: ecs-agent-updater
desc: Deploys a lambda function and associated cloudwatch trigger to periodically check and update the ECS agent on ECS container instances.
depends: lambda-function, lambda-schedule
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_iam_policy_document" "ecs_access_policy" {
  statement {
    sid = "1"
    effect = "Allow"

    actions = [
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:UpdateContainerAgent"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_access_policy" {
  policy = data.aws_iam_policy_document.ecs_access_policy.json
}

module "lambda" {
  source = "../lambda-function"

  aws_region        = var.aws_region
  function_name     = var.function_name
  function_handler  = "lambda_function.run"
  runtime           = "python3.6"
  timeout           = var.timeout
  code_repository   = "https://github.com/richardjkendall/ecs-agent-update.git"
  
  execution_role_policies = [
    aws_iam_policy.ecs_access_policy.arn
  ]

  environment_variables = {
    dummy = "dummy"
  }
}

module "schedule" {
  source = "../lambda-schedule"

  aws_region          = var.aws_region
  function_name       = module.lambda.function_name
  schedule_expression = "rate(12 hours)"
}