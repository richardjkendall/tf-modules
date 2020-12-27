/*
title: keycloak-user-browser
desc: Deploys a small read-only user brower for Keycloak behind OIDC auth.
depends: ecs-service
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
    
    keycloak_server             = var.kc_server 
    keycloak_client_id          = var.kc_client_id 
    keycloak_client_secret      = var.kc_client_secret_ssm_name
  })

}