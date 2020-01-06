variable "aws_region" {
  description = "region where provisioning should happen"
}

variable "cluster_name" {
  description = "name of cluster where service runs"
}

variable "service_name" {
  description = "name of ECS service"
}

variable "image_repo" {
  description = "name of image repo (ECR repo)"
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

variable "build_timeout" {
  default = "5"
  description = "how long should we wait (in minutes) before assuming a build has failed"
}