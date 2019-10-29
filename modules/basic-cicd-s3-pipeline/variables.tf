variable "aws_region" {}

variable "gh_username" {}

variable "gh_token_sm_param_name" {}

variable "gh_repo" {}

variable "site_name" {}

variable "cf_distribition" {}

variable "s3_bucket" {}

variable "build_timeout" {
  default = "5"
}

variable "cf_invalidate" {
  default = "yes"
}