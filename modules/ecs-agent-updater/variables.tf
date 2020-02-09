variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "function_name" {
  type = string
  description = "name of lambda function"
  default = "EcsAgentUpdater"
}

variable "timeout" {
  description = "how many seconds should the function be allowed to run for"
  type = number
  default = 20
}