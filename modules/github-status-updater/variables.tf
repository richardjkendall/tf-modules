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