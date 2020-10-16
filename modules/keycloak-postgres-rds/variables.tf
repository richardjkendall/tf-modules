variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "vpc_id" {
  type = string
  description = "vpc where DB will be provisioned"
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

variable "cpu" {
  type = number
  description = "cpu allocation to the keycloak task"
  default = 512
}

variable "memory" {
  type = number
  description = "memory allocation to the keycloak task"
  default = 512
}

variable "keycloak_admin_user_password_secret" {
  description = "name of secret containing keycloak admin user password"
  type = string
}

variable "postgres_password_secret" {
  description = "name of secret containing password for postgres"
  type = string
}

variable "client_sec_group" {
  type = string
  description = "security group for the instances which should have access to the database"
}

variable "keycloak_image" {
    type = string
    description = "should we use a different image for keycloak"
    default = "jboss/keycloak"
}

variable "db_storage_size" {
    type = number
    description = "number of GB of storage which is allocated"
    default = 10
}

variable "db_storage_type" {
    type = string
    description = "type of storage used for database"
    default = "gp2"
}

variable "db_instance_class" {
    type = string
    description = "what class of underlying instances should be used"
    default = "db.t3.small"
}

variable "db_multi_az" {
    type = bool
    description = "should the database be deployed across multiple AZs"
    default = false
}