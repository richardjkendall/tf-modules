variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "vpc_id" {
    description = "vpc where DB should be created"
    type = string
}

variable "postgres_version" {
    type = string
    description  = "version of postgres to use"
    default = "12.3"
}

variable "database_name" {
    type = string
    description = "name of the database to create"
}

variable "database_user" {
    type = string
    description = "username for root account"
}

variable "database_password" {
    type = string
    description = "password for root account"
}

variable "storage_size" {
    type = number
    description = "number of GB of storage which is allocated"
    default = 10
}

variable "storage_type" {
    type = string
    description = "type of storage used for database"
    default = "gp2"
}

variable "instance_class" {
    type = string
    description = "what class of underlying instances should be used"
    default = "db.t3.small"
}

variable "allowed_ingress_group" {
    type = string
    description = "security group containing instances which can communicate with the database instance"
}

variable "multi_az" {
    type = bool
    description = "should the database be deployed across multiple AZs"
    default = false
}