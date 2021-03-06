/*
title: keycloak-postgres-rds
desc: Deploys an instance of JBoss Keycloak backed by a postgres database running on RDS
partners: ecs-haproxy
depends: ecs-service, postgres-rds
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_ssm_parameter" "db_password" {
  name = var.postgres_password_secret
}

module "rds" {
  source = "../postgres-rds"

  aws_region = var.aws_region
  vpc_id     = var.vpc_id

  database_name         = "keycloak"
  database_user         = "keycloak"
  database_password     = data.aws_ssm_parameter.db_password.value
  allowed_ingress_group = var.client_sec_group
  storage_size          = var.db_storage_size
  storage_type          = var.db_storage_type
  instance_class        = var.db_instance_class
  multi_az              = var.db_multi_az
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
  depends_on = [module.rds]

  source = "../ecs-service"

  aws_region                    = var.aws_region
  cluster_name                  = var.cluster_name
  service_name                  = var.service_name
  service_registry_id           = var.service_registry_id
  service_registry_service_name = var.service_registry_service_name

  task_name          = "keycloak"
  image              = "not used"
  cpu                = var.cpu
  memory             = var.memory
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
    cpu           = var.cpu
    memory        = var.memory
    admin_passwd  = var.keycloak_admin_user_password_secret
    db_passwd     = var.postgres_password_secret
    db_host       = module.rds.db_host
    image         = var.keycloak_image
    java_opts     = var.java_opts
  })

  task_role_policies = [
    aws_iam_policy.ses_send_policy.id
  ]

}

