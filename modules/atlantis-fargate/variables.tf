variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "ecs_cluster_name" {
  default = "atlantis"
  description = "name of the ECS cluster created"
}

variable "task_def_name" {
  default = "atlantis"
  description = "name of the task definition created for atlantis"
}

variable "root_domain" {
  description = "root domain where this is provisioned e.g. example.com, you should have a Route53 zone for this domain in your aws account"
}

variable "host_name" {
  default = "atlantis"
  description = "host name used for atlantis e.g. [atlantis].example.com"
}

variable "gh_user" {
  description = "GitHub username used to access your repos (and dependencies)"
}

variable "gh_token_secret_name" {
  description = "name of SSM parameter where the GitHub Oauth token is stored"
}

variable "gh_repo_whitelist" {
  description = "what repos can be picked up by atlantis e.g. github.com/blah/aws*"
}

variable "gh_webhook_secret_name" {
  description = "name of SSM parameter where GitHub webhook secret is stored"
}

variable "vpc_id" {
  description = "ID for the VPC we will use"
}

variable "allowed_ips" {
  type        = "list"
  default     = ["0.0.0.0/0"]
  description = "list of ip ranges allowed to access the atlantis endpoint, only used if the GH API does not return a list"
}

variable "lb_subnets" {
  type = "list"
  description = "subnets for the load balancer, should have public IP assignment possible + IGW attached"
}

variable "task_subnets" {
  type = "list"
  description = "subnets where the task will launch, can be the same as lb_subnets, can be different if you have private subnets for applications.  Needs internet access either via IGW, NAT G/W or NAT instance."
}