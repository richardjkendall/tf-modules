variable "aws_region" {}

variable "sitname_prefix" {}

variable "domain_root" {}

variable "aws_region" {}

variable "access_log_bucket" {}

variable "access_log_prefix" {}

variable "http_version" {
  default = "http2"
}

variable "root_object_location" {
  default = "index.html"
}

variable "price_class" {
  default = "PriceClass_All"
}

variable "default_ttl" {
  default     = 60
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache"
}

variable "min_ttl" {
  default     = 0
  description = "Minimum amount of time that you want objects to stay in CloudFront caches"
}

variable "max_ttl" {
  default     = 3600
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache"
}