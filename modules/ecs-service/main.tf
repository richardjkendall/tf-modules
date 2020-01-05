provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

locals {
  container_task_def = [{
    name          = "${var.task_name}"
    image         = "${var.image}"
    cpu           = var.cpu
    memory        = var.memory
    portMappings  = var.port_mappings
    
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = "/ecs/${var.cluster_name}/${var.service_name}"
        awslogs-region = "${var.aws_region}"
        awslogs-stream-prefix = "${var.task_name}"
      }
    }
    
    secrets     = var.secrets
    environment = var.environment
  }]
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = "${var.cluster_name}"
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/${var.cluster_name}/${var.service_name}"
}

resource "aws_ecs_task_definition" "task" {
  depends_on = [aws_cloudwatch_log_group.logs]

  family                    = "${var.service_name}-${var.task_name}"
  network_mode              = "${var.network_mode}"
  requires_compatibilities  = ["EC2"]
  cpu                       = var.cpu
  memory                    = var.memory
  container_definitions     = "${jsonencode(local.container_task_def)}"
}

resource "aws_service_discovery_service" "discovery" {
  name = "${var.service_registry_service_name}"
  
  dns_config {
    namespace_id = "${var.service_registry_id}"
    
    dns_records {
      ttl   = 60
      type  = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 2
  }
}

resource "aws_ecs_service" "service" {
  name              = "${var.service_name}"
  cluster           = "${data.aws_ecs_cluster.cluster.id}"
  task_definition   = "${aws_ecs_task_definition.task.arn}"
  desired_count     = var.number_of_tasks
  launch_type       = "EC2"

  placement_constraints {
    type = "distinctInstance"
  }

  service_registries {
    registry_arn    = "${aws_service_discovery_service.discovery.arn}"
    container_name  = "${var.task_name}"
    container_port  = var.port_mappings[0].containerPort
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer == null ? [] : [var.load_balancer]
    
    content {
      target_group_arn  = var.load_balancer.target_group_arn
      container_name    = var.load_balancer.container_name
      container_port    = var.load_balancer.container_port
    }
  }
}