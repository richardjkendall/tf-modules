/*
title: keycloak-postgres
desc: Deploys an instance of JBoss Keycloak backed by a postgres database on an ECS cluster
partners: ecs-haproxy
depends: ecs-service
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_iam_policy_document" "ses_send_policy_document" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
      "ses:SendTemplatedEmail"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ses_send_policy" {
  policy = data.aws_iam_policy_document.ses_send_policy_document.json
}

module "service" {
  source = "../ecs-service"

  aws_region                    = var.aws_region
  cluster_name                  = var.cluster_name
  service_name                  = var.service_name
  service_registry_id           = var.service_registry_id
  service_registry_service_name = var.service_registry_service_name

  task_name          = "keycloak"
  image              = "not used"
  cpu                = 1024
  memory             = 1024
  network_mode       = "bridge"
  number_of_tasks    = 1

  port_mappings = [
    {
      containerPort = 8080
      hostPort = 0
      protocol = "tcp"
    }
  ]

  task_def_override = templatefile("${path.module}/tasks.json", {
    region        = var.aws_region
    cluster       = var.cluster_name
    service       = var.service_name
    admin_passwd  = var.keycloak_admin_user_password_secret
    db_passwd     = var.postgres_password_secret
    image         = var.keycloak_image
  })

  efs_volumes = [
    {
      name          = "data"
      fileSystemId  = var.efs_filesystem_id
      rootDirectory = var.postgres_data_directory 
    }
  ]

  task_role_policies = [
    aws_iam_policy.ses_send_policy.id
  ]
  
}