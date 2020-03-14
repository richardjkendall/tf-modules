provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

module "ecs_webdav-server" {
  source = "../ecs-service/"

  aws_region      = var.aws_region
  cluster_name    = var.cluster_name
  service_name    = var.service_name
  task_name       = var.task_name
  image           = "richardjkendall/webdav-server:${var.tag_name}"
  cpu             = var.cpu
  memory          = var.memory
  number_of_tasks = 1

  port_mappings = [{
    containerPort = 80
    protocol = "tcp"
    hostPort = 0
  }]

  environment = [
    { name = "REGION"
      value = var.aws_region },
    { name = "TABLE"
      value = var.users_table },
    { name = "REALM"
      value = var.auth_realm },
    { name = "CACHE_FOLDER"
      value = var.cache_dir },
    { name = "CACHE_DURATION"
      value = var.cache_duration }
  ]

  efs_volumes = [
    {
      name          = "davroot"
      fileSystemId  = var.efs_filesystem_id
      rootDirectory = var.dav_root_directory
    },
    {
      name          = "davlockdb"
      fileSystemId  = var.efs_filesystem_id
      rootDirectory = var.dav_lockdb_directory
    }
  ]

  mount_points = [
    {
      sourceVolume  = "davlockdb"
      containerPath = "/dav/db"
      readOnly      = false
    },
    {
      sourceVolume  = "davroot"
      containerPath = "/dav/root"
      readOnly      = false
    }
  ]

  service_registry_id           = var.service_registry_id
  service_registry_service_name = var.service_registry_service_name
}