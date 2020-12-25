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

variable "log_bucket" {
  description = "s3 bucket where cloudfront distribution logs are stored"
  type = string
}

variable "log_prefix" {
  description = "s3 prefix for the cloudfront distribution logs"
  type = string
}

variable "hostname" {
  description = "hostname of the site hosted on cloudfront"
  type = string
}

variable "filter" {
  description = "filter for S3 logs used by the tool"
  default = []
  type = list(object({
    dateFragment = string
  }))
}