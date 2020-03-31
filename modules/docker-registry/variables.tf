variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "cluster_name" {
  description = "name of cluster where service will run"
  type = string
}

variable "service_name" {
  description = "name of ECS service"
  type = string
}

variable "service_registry_id" {
  description = "ID for the AWS service discovery namespace we will use"
  type = string
}

variable "service_registry_service_name" {
  description = "name for service we will use in the service registry"
  type = string
}

variable "users_table" {
  description = "name of users table in dynamodb"
  type = string
  default = "basicAuthUsers"
}

variable "auth_realm" {
  description = "realm where users should exist"
  type = string
  default = "dav"
}

variable "cache_dir" {
  description = "dir where cache DB is held"
  type = string
  default = "/tmp"
}

variable "cache_duration" {
  description = "seconds that cache entries live for"
  type = string
  default = "120"
}

variable "efs_filesystem_id" {
  description = "ID for filesystem used to store data and config"
  type = string
}

variable "repo_data_directory" {
  description = "directory on the filesystem which contains the repository data directory"
  type = string
}