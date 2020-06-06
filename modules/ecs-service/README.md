ecs-service
======


Deploys a simple ECS service backed by a simple task.  You can pass in your own task definition if you want to achieve more complex results.

Works with
------

* [ecs-with-spot-fleet](../ecs-with-spot-fleet/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v57 | ecs-service-with-cicd: adding support for notifications | `dea61cd`
v36 | ecs-service: added support for task role | `95295cc`
v27 | added prom-grafana module | `4662e19`
v25 | ecs-service: added support for EFS volumes | `4592a95`
v24 | fixing execution role arn on service | `3b1802e`
v21 | fix healthcheck command type | `0b69ad1`
v18 | adding ECS pipeline and ECS service with pipeline | `53a5c33`
v16 | adding haproxy module and small changes to the ecs-service module to support it | `fcec2c0`
v14 | added basic ECS service module | `d9594d4`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`cluster_name` | `not specified` | name of cluster where service will run | ``
`service_name` | `not specified` | name of ECS service | ``
`task_def_override` | `any` | used to override the task definition with an external task def | `ERROR: cannot convert!`
`task_name` | `not specified` | name of ECS container | ``
`service_registry_id` | `not specified` | ID for the AWS service discovery namespace we will use | ``
`service_registry_service_name` | `not specified` | name for service we will use in the service registry | ``
`image` | `not specified` | image task will use | ``
`cpu` | `number` | CPU units for the task | `128`
`memory` | `number` | memory for the task | `256`
`port_mappings` | `list(object({containerPort=number,hostPort=number,protocol=string}))` | list of port mappings for the task | ``
`secrets` | `list(object({name=string,valueFrom=string}))` | environment variables from secrets | `[]`
`environment` | `list(object({name=string,value=string}))` | non scret environment variables | `[]`
`healthcheck` | `object({command=list(string),interval=number,retries=number,startPeriod=number,timeout=number})` | healthcheck for the container | `ERROR: cannot convert!`
`efs_volumes` | `list(object({fileSystemId=string,name=string,rootDirectory=string}))` | volumes for the task | `[]`
`mount_points` | `list(object({containerPath=string,readOnly=bool,sourceVolume=string}))` | mount points for the task definition | `[]`
`network_mode` | `not specified` | network mode to use for tasks | `bridge`
`number_of_tasks` | `number` | number of tasks to spawn for service | `2`
`load_balancer` | `object({container_name=string,container_port=number,target_group_arn=string})` | application load balancer associated with the service | `ERROR: cannot convert!`
`task_role_policies` | `list(string)` | list of ARNs of policies to attach to the task role | `[]`

