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

variable "runtime" {
  type = string
  description = "runtime for lambda function"
  default = "python3.6"
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

variable "environment_variables" {
  type = map(string)
  default = {}
  description = "map of environment variables passed to the function"
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

variable "execution_role_policies" {
  type = list(string)
  description = "list of arns for policies which should be attached to the ECS instance role"
}

variable "publish" {
  type = bool
  default = false
  description = "should we publish this lambda function, should be true for lambda@edge"
}

variable "build_environment" {
  type = map(string)
  default = {}
  description = "map of environment variables passed to the build job"
}