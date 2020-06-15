variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "site_name" {
  description = "FQDN of site e.g. www.example.com"
  type = string
}

variable "cf_distribution" {
  description = "ID of the CF distribution to be updated on each deployment"
  type = string
}

variable "source_s3_bucket" {
  description = "S3 bucket which is the source for the build process"
  type = string
}

variable "source_s3_prefix" {
  description = "S3 bucket prefix used for the source build zip file"
  type = string
}

variable "s3_bucket" {
  description = "S3 bucket where the files behind the CF distribution are placed"
  type = string
}

variable "build_timeout" {
  default = "5"
  description = "how long should we wait (in minutes) before assuming a build has failed"
  type = string
}

variable "cf_invalidate" {
  default = "yes"
  description = "should the CF distribution be invalidated for each deployment"
  type = string
}

variable "encrypt_buckets" {
  type = bool
  default = false
  description = "encrypt buckets with default AWS keys"
}

variable "allow_root" {
  type = bool
  default = false
  description = "allow build process to become root (sudo)"
}

variable "build_image" {
  type = string
  default = "aws/codebuild/standard:2.0"
  description = "what build image should be used to run the build job"
}