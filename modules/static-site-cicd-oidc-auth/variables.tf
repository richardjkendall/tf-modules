variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "sitename_prefix" {
  description = "prefix of site name e.g. for www.example.com this would be www"
  type = string
}

variable "domain_root" {
  description = "domain root for site e.g. example.com.  This must be available in Route53."
  type = string
}

variable "access_log_bucket" {
  description = "S3 bucket where access logs will be placed"
  type = string
}

variable "access_log_prefix" {
  description = "prefix used for any access logs written to S3"
  type = string
}

variable "gh_username" {
  description = "GitHub username used to access your site source code repo"
  type = string
}

variable "gh_secret_sm_param_name" {
  description = "name of SSM parameter where GitHub webhook secret is stored"
  type = string
}

variable "gh_token_sm_param_name" {
  description = "name of SSM parameter where the GitHub Oauth token is stored"
  type = string
}

variable "gh_repo" {
  description = "name of repo containing site source and buildspec.yml file"
  type = string
}

variable "gh_branch" {
  default = "master"
  description = "branch of git repo to use for changes"
  type = string
}

variable "keycloak_host" {
  type = string
  description = "name of keycloak host"
}

variable "realm" {
  type = string
  description = "keycloak auth realm"
}

variable "client_id" {
  type = string
  description = "client ID for keycloak client"
}

variable "client_secret" {
  type = string
  description = "client secret for keycloak client"
}

variable "auth_cookie_name" {
  type = string
  description = "name of cookie used to hold auth token"
  default = "auth"
}

variable "refresh_cookie_name" {
  type = string
  description = "name of cookie used to hold refresh token"
  default = "rt"
}

variable "val_api_url" {
  type = string
  description = "URL for JWT validation API"
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