/*
title: basicauth-user-manager
desc: Deploys a service to manage users in a dynamodb table which is used by the basicauth reverse proxy module.
depends: ecs-service
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

resource "aws_dynamodb_table" "auth_table" {
  count = var.create_table ? 1 : 0

  name            = var.ddb_table
  billing_mode    = "PAY_PER_REQUEST"
  hash_key        = "realm"
  range_key       = "user"

  attribute {
    name = "realm"
    type = "S"
  }

  attribute {
    name = "user"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

data "aws_iam_policy_document" "dynamodb_access_policy" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan"
    ]
    resources = [
      "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.ddb_table}"
    ]
  }
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  policy = data.aws_iam_policy_document.dynamodb_access_policy.json
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
  memory             = 128+256
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
    region                      = var.aws_region
    cluster                     = var.cluster_name
    service                     = var.service_name
    
    access_ddb_table = var.ddb_table
    access_realm     = var.admin_realm

    managed_ddb_table     = var.ddb_table
    admin_realm           = var.admin_realm
    admin_user            = var.admin_user
    admin_salt            = var.admin_salt
    admin_password_secret = var.admin_password_ssm_secret_name
  })

  task_role_policies = [
    aws_iam_policy.dynamodb_access_policy.arn
  ]

}