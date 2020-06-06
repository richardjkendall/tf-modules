web-jumpost
======


Deploys a browser based console protected behind OIDC login.

Depends on
------

* [ecs-service](../ecs-service/README.md)



Works with
------

* [ecs-haproxy](../ecs-haproxy/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v37 | web-jumphost-basic: added task role to access dynamodb table | `d06f262`
v35 | web-jumphost-basic: adding jumphost with basic auth support | `3849551`
v30 | web-jumphost: added support for external EFS mounts | `eaafacf`
v28 | web-jumphost: first version | `beb718d`

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
`read_only_filesystem` | `bool` | should the filesytem be read only | `false`
`efs_volumes` | `list(object({fileSystemId=string,name=string,rootDirectory=string}))` | volumes for the task | `[]`
`mount_points` | `list(object({containerPath=string,readOnly=bool,sourceVolume=string}))` | mount points for the task definition | `[]`

