variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "sitename_prefix" {
  description = "prefix of site name e.g. for www.example.com this would be www"
}

variable "domain_root" {
  description = "domain root for site e.g. example.com.  This must be available in Route53."
}

variable "redirect_target_domain" {
  description = "domain to use for redirect"
}

variable "redirect_protocol" {
  description = "protocol to use for redirect"
  default = "https"
}