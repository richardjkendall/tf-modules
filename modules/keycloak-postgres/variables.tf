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

variable "postgres_data_directory" {
  description = "directory on the filesystem which contains the postgres database"
  type = string
}

variable "keycloak_admin_user_password_secret" {
  description = "name of secret containing keycloak admin user password"
  type = string
}

variable "postgres_password_secret" {
  description = "name of secret containing password for postgres"
  type = string
}