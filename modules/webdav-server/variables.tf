variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "cluster_name" {
  description = "name of cluster where service will run"
}

variable "service_name" {
  description = "name of ECS service"
  default = "webdav"
}

variable "task_name" {
  description = "name of ECS container"
  default = "webdav"
}

variable "tag_name" {
  description = "name of tag of webdav image to use"
  type = string
  default = "latest"
}

variable "service_registry_id" {
  description = "ID for the AWS service discovery namespace we will use"
}

variable "service_registry_service_name" {
  description = "name for service we will use in the service registry"
  default = "_files._tcp"
}

variable "cpu" {
  description = "CPU units for the task"
  default = 128
  type = number
}

variable "memory" {
  description = "memory for the task"
  default = 128
  type = number
}

variable "efs_filesystem_id" {
  description = "ID for filesystem used to store files"
  type = string
}

variable "dav_root_directory" {
  description = "directory on the filesystem which is the root of the dav filesystem"
  type = string
}

variable "dav_lockdb_directory" {
  description = "directory on the filesystem which contains the dav lockdb"
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