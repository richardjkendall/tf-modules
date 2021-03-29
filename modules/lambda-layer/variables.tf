variable "layer_name" {
    type = string
    description = "Name of the lambda layer"
}

variable "runtime" {
  type = string
  description = "runtime for lambda function"
  default = "python3.7"
}

variable "code_repository" {
  description = "code repository for the lambda function"
  type = string
}

variable "build_environment" {
  type = map(string)
  default = {}
  description = "map of environment variables passed to the build job"
}

variable "layer_bucket" {
  type = string
  description = "Name of the bucket used to store the layer file"
}