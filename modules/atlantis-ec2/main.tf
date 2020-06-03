/*
title: atlantis-ec2
desc: This is a generalised version of the atlantis module which runs on EC2 backed ECS.  It is designed to work with the ecs-haproxy module to be exposed via service discovery
depends: ecs-service, ecs-haproxy
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "service_role_policy" {
  statement {
    sid = "1"
    effect = "Allow"

    actions = ["ssm:GetParameters"]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.gh_token_secret_name}",
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.gh_webhook_secret_name}"
    ]
  }

  statement {
    sid = "2"
    effect = "Allow"

    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/atlantis_terragrunt_deployment_role"
    ]
  }
}

resource "aws_iam_policy" "service_role_policy" {
  policy = data.aws_iam_policy_document.service_role_policy.json
}

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

data "aws_iam_policy_document" "deployment_role_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = [
        "*"
      ]
      type        = "AWS"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "deployment_role" {
  name               = "atlantis_terragrunt_deployment_role"
  assume_role_policy = data.aws_iam_policy_document.deployment_role_assume_policy.json
}

data "aws_iam_policy_document" "deployment_role" {
    statement {
        sid = "1"

        actions = [
            "route53:*",
            "ec2:*",
            "lambda:*",
            "logs:*",
            "cloudfront:*",
            "elasticloadbalancing:*",
            "s3:*",
            "dynamodb:*",
            "ecs:*",
            "apigateway:*",
            "servicediscovery:*"
        ]

        resources = ["*"]
    }

    statement {
        sid = "2"

        actions = [
            "ssm:GetParameters",
            "ssm:GetParameter"
        ]

        resources = ["*"]
    }

    statement {
        sid = "3"

        actions = [
            "secretsmanager:Describe*",
            "secretsmanager:Get*"
        ]

        resources = ["*"]
    }

    statement {
        sid = "4"

        actions = [
            "iam:AttachGroupPolicy",
            "iam:AttachRolePolicy",
            "iam:CreateGroup",
            "iam:CreatePolicy",
            "iam:CreatePolicyVersion",
            "iam:CreateRole",
            "iam:DeleteGroup",
            "iam:DeleteGroupPolicy",
            "iam:DeletePolicy",
            "iam:DeleteRole",
            "iam:DeleteRolePolicy",
            "iam:DetachGroupPolicy",
            "iam:DetachRolePolicy",
            "iam:GetGroupPolicy",
            "iam:GetPolicy",
            "iam:GetPolicyVersion",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:ListAttachedGroupPolicies",
            "iam:ListAttachedRolePolicies",
            "iam:ListGroupPolicies",
            "iam:ListGroups",
            "iam:ListPolicies",
            "iam:ListPolicyVersions",
            "iam:ListRolePolicies",
            "iam:ListRoles",
            "iam:UpdateGroup",
            "iam:UpdateRole",
            "iam:CreateInstanceProfile"
        ]

        resources = ["*"]
    }

    statement {
        sid = "5"

        actions = [
            "acm:DescribeCertificate",
            "acm:GetCertificate",
            "acm:ListCertificates",
            "acm:RequestCerfificate"
        ]

        resources = ["*"]
    }
}

resource "aws_iam_policy" "deployment_role_policy" {
  policy = data.aws_iam_policy_document.deployment_role.json
}

resource "aws_iam_role_policy_attachment" "deployment_role_policy_attach" {
  role       = aws_iam_role.deployment_role.name
  policy_arn = aws_iam_policy.deployment_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "user_deployment_policies" {
  count       = length(var.deployment_role_policies)

  role        = aws_iam_role.deployment_role.name
  policy_arn  = element(var.deployment_role_policies, count.index)
}

resource "random_string" "random_secret" {
  length = 20
  special = true
}

module "service" {
  source = "../ecs-service"

  aws_region                    = var.aws_region
  cluster_name                  = var.ecs_cluster_name
  service_name                  = var.service_name
  service_registry_id           = var.service_registry_id
  service_registry_service_name = var.service_registry_service_name

  task_name          = "proxy"
  image              = "not used"
  cpu                = var.cpu + 128
  memory             = var.memory + 128
  network_mode       = "bridge"
  number_of_tasks    = 1
  efs_volumes        = []

  task_role_policies = [
    aws_iam_policy.service_role_policy.arn,
    aws_iam_policy.dynamodb_access_policy.arn
  ]

  port_mappings = [
    {
      containerPort = 80
      hostPort = 0
      protocol = "tcp"
    }
  ]

  task_def_override = templatefile("${path.module}/atlantis.json", {
    gh_user           = var.gh_user
    whitelist         = var.gh_repo_whitelist
    url               = "https://${var.host_name}.${var.root_domain}"
    iam_role          = aws_iam_role.deployment_role.arn
    repoconfig        = jsonencode(file("${path.module}/repoconfig.json"))
    gh_webhook_secret = var.gh_webhook_secret_name
    gh_token          = var.gh_token_secret_name
    region            = var.aws_region
    random_secret     = random_string.random_secret.result
    cpu               = var.cpu
    memory            = var.memory

    /* values for the proxy */
    cluster           = var.ecs_cluster_name
    service           = var.service_name
    table             = var.users_table
    realm             = var.auth_realm
    folder            = var.cache_dir
    duration          = var.cache_duration
  })

}