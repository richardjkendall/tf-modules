variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "gh_username" {
  description = "GitHub username used to access your site source code repo"
}

variable "gh_secret_sm_param_name" {
  description = "name of SSM parameter where GitHub webhook secret is stored"
}

variable "gh_token_sm_param_name" {
  description = "name of SSM parameter where the GitHub Oauth token is stored"
}

variable "gh_repo" {
  description = "name of repo containing site source and buildspec.yml file"
}

variable "gh_branch" {
  default = "master"
  description = "branch of git repo to use for changes"
}

variable "site_name" {
  description "FQDN of site e.g. www.example.com"
}

variable "cf_distribution" {
  description = "ID of the CF distribution to be updated on each deployment"
}

variable "s3_bucket" {
  description = "S3 bucket where the files behind the CF distribution are placed"
}

variable "build_timeout" {
  default = "5"
  description = "how long should we wait (in minutes) before assuming a build has failed"
}

variable "cf_invalidate" {
  default = "yes"
}