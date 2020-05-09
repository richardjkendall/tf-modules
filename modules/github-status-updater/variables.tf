variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "gh_username" {
  type = string
  description = "github username"
}

variable "gh_access_token_parameter" {
  type = string
  description = "name of ssm parameter which contains the github access token"
}

variable "delay_seconds" {
  type = number
  default = 10
  description = "delay seconds to set on the sqs queue which picks up messages from sns topic"
}

variable "encrypt" {
  type = bool
  default = false
  description = "should encryption be enabled on SQS queues"
}