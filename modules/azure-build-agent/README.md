azure-build-agent
======


Deploys an instance of the azure devops build agent on ECS

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
`service_name` | `string` | name of ECS service | `azure-build-agent`
`task_name` | `string` | name of ECS container | `build-agent`
`image` | `string` | image task will use | `richardjkendall/azure-devops-agent`
`cpu` | `number` | CPU units for the task | `512`
`memory` | `number` | memory for the task | `512`
`task_role_policies` | `list(string)` | list of ARNs of policies to attach to the task role | `[]`
`azp_url` | `string` | URL of Azure devops instance | ``
`azp_pool` | `string` | Pool name to use for agent | ``
`azp_token_ssm_parameter` | `string` | name of SSM parameter which contains the token used for the build agent | ``
`launch_type` | `string` | should we use EC2 or fargate | `EC2`
`use_spot` | `bool` | use spot capacity?  only takes effect for a the fargate launch type | `false`
`fargate_task_subnets` | `list(string)` | list of subnets to use for tasks launched on fargate | `[]`
`fargate_task_vpc` | `string` | vpc to use when creating fargate version of the task | ``

