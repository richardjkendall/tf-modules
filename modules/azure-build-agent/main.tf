/*
title: azure-build-agent
desc: Deploys an instance of the azure devops build agent on ECS
depends: ecs-service
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

module "ecs_build_agent" {
  source = "../ecs-service/"

  aws_region      = var.aws_region
  cluster_name    = var.cluster_name
  service_name    = var.service_name
  task_name       = var.task_name
  image           = var.image 
  cpu             = var.cpu
  memory          = var.memory
  launch_type     = var.launch_type
  network_mode    = var.launch_type == "FARGATE" ? "awsvpc" : "bridge"

  use_spot        = var.use_spot
  number_of_tasks = 1

  port_mappings = []

  environment = [
    { name = "AZP_URL"
      value = var.azp_url },
    { name = "AZP_POOL"
      value = var.azp_pool }
  ]

  secrets = [
    { name = "AZP_TOKEN"
      valueFrom = var.azp_token_ssm_parameter }
  ]

  task_role_policies = var.task_role_policies

  fargate_task_subnets    = var.fargate_task_subnets
  fargate_task_sec_groups = var.launch_type == "FARGATE" ? [aws_security_group.allow_out.0.id] : []
}

resource "aws_security_group" "allow_out" {
  count = var.launch_type == "FARGATE" ? 1 : 0

  vpc_id = var.fargate_task_vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}