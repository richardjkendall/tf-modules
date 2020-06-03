variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "ecs_cluster_name" {
  default = "atlantis"
  description = "name of the ECS cluster, should be an existing cluster for the EC2 launch type"
  type = string
}

variable "service_name" {
  description = "name of ECS service"
  type = string
  default = "atlantis"
}

variable "service_registry_id" {
  description = "ID for the AWS service discovery namespace we will use"
  type = string
}

variable "service_registry_service_name" {
  description = "name for service we will use in the service registry"
  type = string
  default = "_atlantis._tcp"
}

variable "cpu" {
  description = "CPU units for the task"
  default = 256
  type = number
}

variable "memory" {
  description = "memory for the task"
  default = 256
  type = number
}

variable "root_domain" {
  description = "root domain where this is provisioned e.g. example.com, you should have a Route53 zone for this domain in your aws account"
  type = string
}

variable "host_name" {
  default = "atlantis"
  description = "host name used for atlantis e.g. [atlantis].example.com"
  type = string
}

variable "gh_user" {
  description = "GitHub username used to access your repos (and dependencies)"
  type = string
}

variable "gh_token_secret_name" {
  description = "name of SSM parameter where the GitHub Oauth token is stored"
  type = string
}

variable "gh_repo_whitelist" {
  description = "what repos can be picked up by atlantis e.g. github.com/blah/aws*"
  type = string
}

variable "gh_webhook_secret_name" {
  description = "name of SSM parameter where GitHub webhook secret is stored"
  type = string
}

variable "deployment_role_policies" {
  type = list(string)
  default = []
  description = "list of arns of custom deployment role policies to be added"
}

variable "users_table" {
  description = "name of users table in dynamodb"
  type = string
  default = "basicAuthUsers"
}

variable "auth_realm" {
  description = "realm where users should exist"
  type = string
  default = "atlantis"
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