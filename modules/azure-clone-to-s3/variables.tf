variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "encrypt_buckets" {
  type = bool
  default = false
  description = "encrypt buckets with default AWS keys"
}

variable "api_username" {
  type = string
  default = "builduser"
  description = "what username should be expected for basic auth user"
}

variable "azure_devops_git_username" {
  type = string
  description = "username to connect to git repos on Azure Devops"
}

variable "api_password_ssm_param" {
  type = string
  description = "name of ssm parameter where basic auth password expected by the API is stored, should be a SecureString"
}

variable "azure_devops_git_token_ssm_param" {
  type = string
  description = "name of ssm parameter where the token with read access to Azure devops repos is stored, should be a SecureString"
}