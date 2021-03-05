/*
title: pipeline-viewer
desc: Deploys an application to view codepipeline/codebuild status.
depends: ecs-service
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_iam_policy_document" "pipe_viewer_policy" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "codepipeline:ListPipelines",
      "codepipeline:GetPipelineState"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "2"
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "3"
    effect = "Allow"
    actions = [
      "logs:GetLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "pipe_viewer_policy" {
  policy = data.aws_iam_policy_document.pipe_viewer_policy.json
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
  cpu                = var.proxy_cpu + var.app_cpu
  memory             = var.proxy_mem + var.app_mem
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
    proxy_cpu                   = var.proxy_cpu
    app_cpu                     = var.app_cpu
    proxy_mem                   = var.proxy_mem
    app_mem                     = var.app_mem
    
    metadata_url                = var.metadata_url
    jwks_uri                    = var.jwks_uri
    client_id                   = var.client_id
    domain                      = var.domain
    port                        = var.port
    scheme                      = var.scheme
    client_secret_ssm_name      = var.client_secret_ssm_name
    crypto_passphrase_ssm_name  = var.crypto_passphrase_ssm_name
  })

  task_role_policies = [
    aws_iam_policy.pipe_viewer_policy.arn
  ]

}