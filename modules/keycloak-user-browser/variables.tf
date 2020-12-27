variable "aws_region" {
  description = "region where provisioning should happen"
  type = string
}

variable "cluster_name" {
  description = "name of cluster where service will run"
  type = string
}

variable "service_name" {
  description = "name of ECS service"
  type = string
}

variable "service_registry_id" {
  description = "ID for the AWS service discovery namespace we will use"
  type = string
}

variable "service_registry_service_name" {
  description = "name for service we will use in the service registry"
  type = string
}

variable "metadata_url" {
  description = "OIDC idp metadata url"
  type = string
}

variable "jwks_uri" {
  description = "OIDC idp web key set uri"
  type = string
}

variable "client_id" {
  description = "OIDC client ID"
  type = string
}

variable "domain" {
  description = "domain name for the proxy service"
  type = string
}

variable "port" {
  description = "port where proxy service is exposed, typically 443"
  type = string
  default = "443"
}

variable "scheme" {
  description = "URL scheme used for proxy endpoint, should be https"
  type = string
  default = "https"
}

variable "client_secret_ssm_name" {
  description = "name of SSM parameter which contains OIDC client secret"
  type = string
}

variable "crypto_passphrase_ssm_name" {
  description = "name of SSM parameter which contains OIDC crypto passphrase"
  type = string
}

variable "kc_server" {
  description = "Keycloak server name"
  type = string
}

variable "kc_client_id" {
  description = "Keycloak client ID"
  type = string
}

variable "kc_client_secret_ssm_name" {
  description = "Name of SSM secret containing the client secret"
  type = string
}