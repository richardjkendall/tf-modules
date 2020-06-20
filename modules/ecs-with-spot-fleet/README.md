ecs-with-spot-fleet
======


Builds an EC2 based ECS clusyer backed by an EC2 instance fleet using spot instances.

Releases
------

|Tag | Message | Commit|
--- | --- | ---
v13 | fixes on ecs cluster module | `288c892`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`ecs_cluster_name` | `not specified` | name of the ECS cluster created | ``
`instance_types` | `list(string)` | list of instance types to use for the fleet, first one in the list is used as the launch template instance type | ``
`ecs_instance_subnets` | `list(string)` | list of subnets in which ECS instances can be launched | ``
`ecs_instance_key_name` | `not specified` | name of the key pair to use for the ECS instances | ``
`ecs_instance_security_groups` | `list(string)` | list of security groups applied to the ECS instances | ``
`ecs_instance_role_policies` | `list(string)` | list of arns for policies which should be attached to the ECS instance role | ``
`number_of_ecs_instances` | `not specified` | number of instances to provision, default is 2 | `2`
`spot_allocation_strategy` | `not specified` | allocation strategy to be used for spot instances | `lowestPrice`

