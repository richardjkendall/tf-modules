variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "ecs_cluster_name" {
  default = "atlantis"
  description = "name of the ECS cluster created"
  type = string
}

variable "cpu" {
  description = "CPU units for the task"
  default = 256
  type = number
}

variable "memory" {
  description = "memory for the task"
  default = 512
  type = number
}

variable "task_def_name" {
  default = "atlantis"
  description = "name of the task definition created for atlantis"
  type = string
}

variable "root_domain" {
  description = "root domain where this is provisioned e.g. example.com, you should have a Route53 zone for this domain in your aws account"
  type = string
}

variable "host_name" {
  default = "atlantis"
  description = "host name used for atlantis e.g. [atlantis].example.com"
  type = string
}

variable "gh_user" {
  description = "GitHub username used to access your repos (and dependencies)"
  type = string
}

variable "gh_token_secret_name" {
  description = "name of SSM parameter where the GitHub Oauth token is stored"
  type = string
}

variable "gh_repo_whitelist" {
  description = "what repos can be picked up by atlantis e.g. github.com/blah/aws*"
  type = string
}

variable "gh_webhook_secret_name" {
  description = "name of SSM parameter where GitHub webhook secret is stored"
  type = string
}

variable "vpc_id" {
  description = "ID for the VPC we will use"
  type = string
}

variable "allowed_ips" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "list of ip ranges allowed to access the atlantis endpoint, only used if the GH API does not return a list"
}

variable "lb_subnets" {
  type = list(string)
  description = "subnets for the load balancer, should have public IP assignment possible + IGW attached"
  default = []
}

variable "task_subnets" {
  type = list(string)
  description = "subnets where the task will launch, can be the same as lb_subnets, can be different if you have private subnets for applications.  Needs internet access either via IGW, NAT G/W or NAT instance."
}

variable "deployment_role_policies" {
  type = list(string)
  default = []
  description = "list of arns of custom deployment role policies to be added"
}

variable "create_lb" {
  description = "should the module create a load balancer or link to an existing one"
  default = true
  type = bool
}

variable "lb_arn" {
  description = "arn of existing load balancer if linking to an existing lb"
  default = ""
  type = string
}

variable "listener_arn" {
  description = "arn of existing load balancer listener if linking to an existing lb"
  default = ""
  type = string
}

variable "rule_priority" {
  description = "priority used for rule on existing alb"
  default = 100
  type = number
}

variable "lb_sec_group_id" {
  description = "id of security group attached to existing alb"
  default = ""
  type = string
}