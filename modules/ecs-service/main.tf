/*
title: ecs-service
desc: Deploys a simple ECS service backed by a simple task.  You can pass in your own task definition if you want to achieve more complex results.
partners: ecs-with-spot-fleet
*/

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

locals {
  container_task_def = [{
    name          = var.task_name
    image         = var.image
    cpu           = var.cpu
    memory        = var.memory
    portMappings  = var.port_mappings
    
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.cluster_name}/${var.service_name}"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = var.task_name
      }
    }
    
    secrets     = var.secrets
    environment = var.environment
    healthCheck = var.healthcheck
    mountPoints = var.mount_points
  }]
}

data "aws_caller_identity" "current" {}

data "aws_ecs_cluster" "cluster" {
  cluster_name = var.cluster_name
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/${var.cluster_name}/${var.service_name}"
}

data "aws_iam_policy_document" "ecs_task_role_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "task_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "task_user_policies" {
  count       = length(var.task_role_policies)

  role        = aws_iam_role.task_role.name
  policy_arn  = element(var.task_role_policies, count.index)
}

data "aws_iam_policy_document" "ecs_service_role_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "service_role_policy" {
  statement {
    sid = "1"
    effect = "Allow"

    actions = ["ssm:GetParameters"]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "service_role_policy" {
  policy = data.aws_iam_policy_document.service_role_policy.json
}

resource "aws_iam_role" "service_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_service_role_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "service_managed_ecs_policy_attach" {
  role       = aws_iam_role.service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "service_role_policy_attach" {
  role       = aws_iam_role.service_role.name
  policy_arn = aws_iam_policy.service_role_policy.arn
}

resource "aws_ecs_task_definition" "task" {
  depends_on = [aws_cloudwatch_log_group.logs]

  family                    = "${var.service_name}-${var.task_name}"
  network_mode              = var.network_mode
  requires_compatibilities  = ["EC2"]
  cpu                       = var.cpu
  memory                    = var.memory
  container_definitions     = coalesce(var.task_def_override, jsonencode(local.container_task_def))

  execution_role_arn        = aws_iam_role.service_role.arn
  task_role_arn             = length(var.task_role_policies) == 0 ? null : aws_iam_role.task_role.arn
  
  dynamic "volume" {
    for_each = var.efs_volumes

    content {
      name = volume.value.name

      efs_volume_configuration {
        file_system_id = volume.value.fileSystemId
        root_directory = volume.value.rootDirectory
      }
    }
  }
}

resource "aws_service_discovery_service" "discovery" {
  name = var.service_registry_service_name
  
  dns_config {
    namespace_id = var.service_registry_id
    
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
  name              = var.service_name
  cluster           = data.aws_ecs_cluster.cluster.id
  task_definition   = aws_ecs_task_definition.task.arn
  desired_count     = var.number_of_tasks
  launch_type       = "EC2"

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type = "spread"
  }

  service_registries {
    registry_arn    = aws_service_discovery_service.discovery.arn
    container_name  = var.task_name
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