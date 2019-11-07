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

variable "gh_repo_whitelist" {}

variable "gh_webhook_secret_name" {}