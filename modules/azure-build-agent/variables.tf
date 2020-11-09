variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "cluster_name" {
  description = "name of cluster where service will run"
  type = string
}

variable "service_name" {
  description = "name of ECS service"
  type = string
  default = "azure-build-agent"
}

variable "task_name" {
  description = "name of ECS container"
  type = string
  default = "build-agent"
}

variable "image" {
  description = "image task will use"
  type = string
  default = "richardjkendall/azure-devops-agent"
}

variable "cpu" {
  description = "CPU units for the task"
  default = 512
  type = number
}

variable "memory" {
  description = "memory for the task"
  default = 512
  type = number
}

variable "task_role_policies" {
  description = "list of ARNs of policies to attach to the task role"
  default = []
  type = list(string)
}

variable "azp_url" {
    description = "URL of Azure devops instance"
    type = string
}

variable "azp_pool" {
    description = "Pool name to use for agent"
    type = string
}

variable "azp_token_ssm_parameter" {
    description = "name of SSM parameter which contains the token used for the build agent"
    type = string
}

variable "launch_type" {
  description = "should we use EC2 or fargate"
  default = "EC2"
  type = string
}

variable "use_spot" {
  description = "use spot capacity?  only takes effect for a the fargate launch type"
  default = false
  type = bool
}

variable "fargate_task_subnets" {
  default = []
  type = list(string)
  description = "list of subnets to use for tasks launched on fargate"
}

variable "fargate_task_vpc" {
  default = ""
  type = string
  description = "vpc to use when creating fargate version of the task"
}