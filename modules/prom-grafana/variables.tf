variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "cluster_name" {
  description = "name of cluster where service will run"
}

variable "service_name" {
  description = "name of ECS service"
}

variable "service_registry_id" {
  description = "ID for the AWS service discovery namespace we will use"
}

variable "service_registry_service_name" {
  description = "name for service we will use in the service registry"
}

variable "efs_filesystem_id" {
  description = "ID for filesystem used to store data and config"
  type = string
}

variable "prom_config_directory" {
  description = "directory on the filesystem which contains the prometheus.yml file"
  type = string
}

variable "prom_data_directory" {
  description = "directory on the filesystem where the prometheus working directory is stored (/prometheus)"
  type = string
}

variable "graf_data_directory" {
  description = "directory on the filesystem where the grafana working directory is stored (/usr/lib/grafana)"
  type = string
}