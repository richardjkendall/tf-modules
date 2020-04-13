variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "lb_subnets" {
  type = list(string)
  description = "subnets for the load balancer, should have public IP assignment possible + IGW attached"
}

variable "vpc_id" {
  description = "ID for the VPC we will use"
  type = string
}

variable "host_name" {
  description = "host name for DNS entry created to point to load balancer"
  default = "haproxy-lb"
  type = string
}

variable "root_domain" {
  description = "root domain used for DNS entry created to point to load balancer"
  type = string
}

variable "def_redir_scheme" {
  description = "url scheme used for default redirect"
  type = string
  default = "http"
}

variable "def_redir_host" {
  description = "host used for default redirect"
  type = string
}

variable "def_redir_path" {
  description = "path for default redirect"
  type = string
  default = "/"
}