variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "sitename_prefix" {
  description = "prefix of site name e.g. for www.example.com this would be www"
}

variable "domain_root" {
  description = "domain root for site e.g. example.com.  This must be available in Route53."
}

variable "access_log_bucket" {
  description = "S3 bucket where access logs will be placed"
}

variable "access_log_prefix" {
  description = "prefix used for any access logs written to S3"
}

variable "http_version" {
  default = "http2"
  description = "version of http to use on this site"
}

variable "root_object_location" {
  default = "index.html"
  description = "name of object to show when root of site is opened in a browser"
}

variable "price_class" {
  default = "PriceClass_All"
  description = "price class for the distribution, for more details see here https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_DistributionConfig.html"
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

variable "viewer_req_edge_lambda_arns" {
  type = list(string)
  default = []
  description = "list of qualified arns or viewer request edge lambdas which should be placed on the distribution, should all be in us-east-1"
}