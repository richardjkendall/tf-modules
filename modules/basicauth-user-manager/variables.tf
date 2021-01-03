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
  default = "user-manager"
}

variable "service_registry_id" {
  description = "ID for the AWS service discovery namespace we will use"
  type = string
}

variable "service_registry_service_name" {
  description = "name for service we will use in the service registry"
  type = string
}

variable "create_table" {
  description = "should we create a new dynamodb table to contain managed users?"
  type = bool
  default = false
}

variable "ddb_table" {
  description = "name of the ddb table to manage"
  type = string
  default = "basicAuthUsers"
}

variable "admin_realm" {
  description = "name of the realm used to control access to the user manager app"
  type = string
  default = "usermanager"
}

variable "admin_user" {
  description = "name of the default admin user that is created"
  type = string
  default = "admin"
}

variable "admin_password_ssm_secret_name" {
  description = "name of the ssm secret which contains the password for the default admin user that is created"
  type = string
}

variable "admin_salt" {
  description = "should we salt the default admin password (yes or no)"
  type = string
  default = "yes"
}