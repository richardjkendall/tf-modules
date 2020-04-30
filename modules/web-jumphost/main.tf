/*
title: web-jumpost
desc: Deploys a browser based console protected behind OIDC login.
depends: ecs-service
partners: ecs-haproxy
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
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
  memory             = 256
  network_mode       = "bridge"
  number_of_tasks    = 1
  efs_volumes        = var.efs_volumes

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
    metadata_url                = var.metadata_url
    jwks_uri                    = var.jwks_uri
    client_id                   = var.client_id
    domain                      = var.domain
    port                        = var.port
    scheme                      = var.scheme
    client_secret_ssm_name      = var.client_secret_ssm_name
    crypto_passphrase_ssm_name  = var.crypto_passphrase_ssm_name
    read_only                   = var.read_only_filesystem
    mount_points                = jsonencode(var.mount_points)
  })

}