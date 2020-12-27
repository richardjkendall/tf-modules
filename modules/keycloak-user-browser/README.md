keycloak-user-browser
======


Deploys a small read-only user brower for Keycloak behind OIDC auth.

Depends on
------

* [ecs-service](../ecs-service/README.md)



Releases
------


There have been no releases yet for this module

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`cluster_name` | `string` | name of cluster where service will run | ``
`service_name` | `string` | name of ECS service | ``
`service_registry_id` | `string` | ID for the AWS service discovery namespace we will use | ``
`service_registry_service_name` | `string` | name for service we will use in the service registry | ``
`metadata_url` | `string` | OIDC idp metadata url | ``
`jwks_uri` | `string` | OIDC idp web key set uri | ``
`client_id` | `string` | OIDC client ID | ``
`domain` | `string` | domain name for the proxy service | ``
`port` | `string` | port where proxy service is exposed, typically 443 | `443`
`scheme` | `string` | URL scheme used for proxy endpoint, should be https | `https`
`client_secret_ssm_name` | `string` | name of SSM parameter which contains OIDC client secret | ``
`crypto_passphrase_ssm_name` | `string` | name of SSM parameter which contains OIDC crypto passphrase | ``
`kc_server` | `string` | Keycloak server name | ``
`kc_client_id` | `string` | Keycloak client ID | ``
`kc_client_secret_ssm_name` | `string` | Name of SSM secret containing the client secret | ``

