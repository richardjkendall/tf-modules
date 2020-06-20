atlantis-ec2
======


This is a generalised version of the atlantis module which runs on EC2 backed ECS.  It is designed to work with the ecs-haproxy module to be exposed via service discovery

Depends on
------

* [ecs-service](../ecs-service/README.md)
* [ecs-haproxy](../ecs-haproxy/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v66 | atlantis-ec2: first version | `03f28de`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`ecs_cluster_name` | `string` | name of the ECS cluster, should be an existing cluster for the EC2 launch type | `atlantis`
`service_name` | `string` | name of ECS service | `atlantis`
`service_registry_id` | `string` | ID for the AWS service discovery namespace we will use | ``
`service_registry_service_name` | `string` | name for service we will use in the service registry | `_atlantis._tcp`
`cpu` | `number` | CPU units for the task | `256`
`memory` | `number` | memory for the task | `256`
`root_domain` | `string` | root domain where this is provisioned e.g. example.com, you should have a Route53 zone for this domain in your aws account | ``
`host_name` | `string` | host name used for atlantis e.g. [atlantis].example.com | `atlantis`
`gh_user` | `string` | GitHub username used to access your repos (and dependencies) | ``
`gh_token_secret_name` | `string` | name of SSM parameter where the GitHub Oauth token is stored | ``
`gh_repo_whitelist` | `string` | what repos can be picked up by atlantis e.g. github.com/blah/aws* | ``
`gh_webhook_secret_name` | `string` | name of SSM parameter where GitHub webhook secret is stored | ``
`deployment_role_policies` | `list(string)` | list of arns of custom deployment role policies to be added | `[]`
`users_table` | `string` | name of users table in dynamodb | `basicAuthUsers`
`auth_realm` | `string` | realm where users should exist | `atlantis`
`cache_dir` | `string` | dir where cache DB is held | `/tmp`
`cache_duration` | `string` | seconds that cache entries live for | `120`

