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

  task_name          = "graf"
  image              = "not used"
  cpu                = 1024
  memory             = 1024
  network_mode       = "bridge"
  number_of_tasks    = 1

  port_mappings = [
    {
      containerPort = 3000
      hostPort = 0
      protocol = "tcp"
    }
  ]

  task_def_override = templatefile("${path.module}/tasks.json", {
    region      = var.aws_region
    cluster     = var.cluster_name
    service     = var.service_name
  })

  efs_volumes = [
    {
      name          = "prom-config"
      fileSystemId  = var.efs_filesystem_id
      rootDirectory = var.prom_config_directory 
    },
    {
      name          = "prom-data"
      fileSystemId  = var.efs_filesystem_id
      rootDirectory = var.prom_data_directory 
    },
    {
      name          = "graf-data"
      fileSystemId  = var.efs_filesystem_id
      rootDirectory = var.graf_data_directory 
    },
  ]
}