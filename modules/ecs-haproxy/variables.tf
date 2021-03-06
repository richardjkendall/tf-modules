variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "cluster_name" {
  description = "name of cluster where service will run"
}

variable "service_name" {
  description = "name of ECS service"
  default = "haproxy"
}

variable "task_name" {
  description = "name of ECS container"
  default = "haproxy"
}

variable "tag_name" {
  description = "name of tag of haproxy image to use"
  type = string
  default = "latest"
}

variable "service_registry_id" {
  description = "ID for the AWS service discovery namespace we will use"
}

variable "service_registry_service_name" {
  description = "name for service we will use in the service registry"
  default = "haproxy-do-not-use"
}

variable "cpu" {
  description = "CPU units for the task"
  default = 128
  type = number
}

variable "memory" {
  description = "memory for the task"
  default = 256
  type = number
}

variable "default_domain" {
  description = "domain where unmatched requests are redirected"
}

variable "namespace_map" {
  description = "map of namespaces to domains"
  type = list(object({
    namespace = string
    domainname = string
  }))
}

variable "refresh_rate" {
  description = "now often (in seconds) service changes be found and applied"
  default = "30"
}

variable "prom_password_ssm_secret" {
  description = "name of ssm secret which contains prom metrics endpoint password"
  type = string
}

variable "stats_password_ssm_secret" {
  description = "name of ssm secret which contains stats endpoint password"
  type = string
}

variable "lb_subnets" {
  type = list(string)
  default = []
  description = "subnets for the load balancer, should have public IP assignment possible + IGW attached"
}

variable "vpc_id" {
  description = "ID for the VPC we will use"
}

variable "listener_cert_arn" {
  description = "arn for the listener certifcate the load balancer will use"
}

variable "host_name" {
  description = "host name for DNS entry created to point to load balancer"
  default = "haproxy-lb"
}

variable "root_domain" {
  description = "root domain used for DNS entry created to point to load balancer"
}

variable "number_of_tasks" {
  description = "number of tasks to spawn for haproxy"
  default = 2
  type = number
}

variable "create_lb" {
  description = "should the module create a load balancer or link to an existing one"
  default = true
  type = bool
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