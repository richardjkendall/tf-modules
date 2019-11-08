variable "aws_region" {}

variable "ecs_cluster_name" {
  default = "atlantis"
}

variable "task_def_name" {
  default = "atlantis"
}

variable "root_domain" {}

variable "host_name" {
  default = "atlantis"
}

variable "gh_user" {}

variable "gh_token_secret_name" {}

variable "gh_repo_whitelist" {}

variable "gh_webhook_secret_name" {}

variable "vpc_id" {}

variable "allowed_ips" {
  type = "list"
  default = ["0.0.0.0/0"]
}

variable "lb_subnets" {
  type = "list"
}

variable "task_subnets" {
  type = "list"
}