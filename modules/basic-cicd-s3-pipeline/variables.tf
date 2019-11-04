variable "aws_region" {}

variable "gh_username" {}

variable "gh_secret_sm_param_name" {}

variable "gh_token_sm_param_name" {}

variable "gh_repo" {}

variable "gh_branch" {
  default = "master"
}

variable "site_name" {}

variable "cf_distribution" {}

variable "s3_bucket" {}

variable "build_timeout" {
  default = "5"
}

variable "cf_invalidate" {
  default = "yes"
}