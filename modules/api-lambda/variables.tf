variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "api_name" {
  type = string
  description = "name of api"
}

variable "function_name" {
  type = string
  description = "name of lambda function"
}

variable "handler" {
  type = string
  description = "name of handler function"
}

variable "runtime" {
  type = string
  description = "rumtime for the lambda function"
  default = "python3.8"
}

variable "timeout" {
  description = "how many seconds should the function be allowed to run for"
  type = number
  default = 20
}

variable "memory" {
  description = "how many MB of memory should be allocated to the function"
  type = number
  default = 128
}

variable "code_repository" {
  type = string
  description = "URL for code to be deployed for the API"
}

variable "http_method" {
  type = string
  description = "HTTP method for the API"
  default = "ANY"
}

variable "stage_name" {
  type = string
  description = "name of the API stage to be deployed"
  default = "prod"
}