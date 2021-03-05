pipeline-viewer
======


Deploys an application to view codepipeline/codebuild status.

Depends on
------

* [ecs-service](../ecs-service/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v108 | pipeline-viewer: new module added | `13ae0e5`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`cluster_name` | `string` | name of cluster where service will run | ``
`service_name` | `string` | name of ECS service | `user-manager`
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
`proxy_cpu` | `number` | CPU units for the proxy container, defaults to 128 | `128`
`app_cpu` | `number` | CPU units for the app container, defaults to 128 | `128`
`proxy_mem` | `number` | Memory units (MB) for the proxy container, defaults to 128 | `128`
`app_mem` | `number` | Memory units (MB) for the app container, defaults to 128 | `128`

