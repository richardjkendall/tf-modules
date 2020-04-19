provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

module "ecs_service" {
  source = "../ecs-service"

  aws_region                    = var.aws_region
  cluster_name                  = var.cluster_name
  service_name                  = var.service_name
  task_name                     = var.task_name
  service_registry_id           = var.service_registry_id
  service_registry_service_name = var.service_registry_service_name
  image                         = var.image
  cpu                           = var.cpu
  memory                        = var.memory
  port_mappings                 = var.port_mappings
  secrets                       = var.secrets
  environment                   = var.environment
  network_mode                  = var.network_mode
  number_of_tasks               = var.number_of_tasks
  load_balancer                 = var.load_balancer
}

module "cicd" {  
  source = "../basic-cicd-ecs-pipeline"
  
  aws_region                = var.aws_region
  gh_username               = var.gh_username
  gh_secret_sm_param_name   = var.gh_secret_sm_param_name
  gh_token_sm_param_name    = var.gh_token_sm_param_name
  gh_repo                   = var.gh_repo
  gh_branch                 = var.gh_branch
  
  cluster_name    = var.cluster_name
  service_name    = var.service_name
  image_repo      = var.image_repo

  send_notifications          = var.send_notifications
  sns_topic_for_notifications = var.sns_topic_for_notifications
  notifications_to_send       = var.notifications_to_send

}