variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "function_name" {
  type = string
  description = "name of lambda function"
}

variable "function_handler" {
  type = string
  description = "handler name for lambda function"
  default = "lambda_function.lambda_handler"
}

variable "memory" {
  description = "MB of memory for function"
  type = number
  default = 256
}

variable "timeout" {
  description = "how many seconds should the function be allowed to run for"
  type = number
  default = 10
}

variable "function_environment" {
  type = map(string)
  default = {}
  description = "map of environment variables passed to the function"
}

variable "function_build_environment" {
  type = map(string)
  default = {}
  description = "map of environment variables passed to the build job"
}

variable "function_code_repository" {
  description = "code repository for the lambda function"
  type = string
}

variable "runtime" {
  type = string
  description = "runtime for lambda function"
  default = "python3.7"
}

variable "execution_role_policies" {
  type = list(string)
  description = "list of arns for policies which should be attached to the lambda function execution role"
}

variable "layer_code_repository" {
  description = "code repository for the lambda function"
  type = string
}

variable "layer_build_environment" {
  type = map(string)
  default = {}
  description = "map of environment variables passed to the build job"
}

variable "layer_bucket" {
  type = string
  description = "Name of the bucket used to store the layer file"
}