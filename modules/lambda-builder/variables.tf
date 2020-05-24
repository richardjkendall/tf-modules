variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "function_name" {
  type = string
  description = "name of lambda function"
}

variable "code_repository" {
  description = "code repository for the lambda function"
  type = string
}

variable "code_branch" {
  description = "branch to use from code repository"
  type = string
  default = "master"
}

variable "build_environment" {
  type = map(string)
  default = {}
  description = "map of environment variables passed to the build job"
}

variable "always_build" {
  type = bool
  default = false
  description = "should we always build or only build when the source code has changed"
}

variable "s3_bucket" {
  type = string
  description = "s3 bucket where deployable assets are placed"
}

variable "s3_prefix" {
  type = string
  default = ""
  description = "prefix for the assets placed in the s3 bucket"
}