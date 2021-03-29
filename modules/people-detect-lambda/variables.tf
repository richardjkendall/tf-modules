variable "aws_region" {
  type = string
  description = "region where provisioning should happen"
}

variable "image_source_bucket" {
  type = string
  description = "S3 bucket which acts as the source for the images"
}

variable "image_output_bucket" {
  type = string
  description = "S3 bucket which acts as the target for the images"
}

variable "image_output_key" {
  type = string
  description = "Key to use as prefix for images which are sent to the output bucket"
}

variable "input_rules" {
  type = list(object({
    prefix = string,
    suffix = string
  }))
  description = "List of rules that can trigger the lambda function to process images"
}