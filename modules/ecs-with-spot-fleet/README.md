# ECS with Spot Fleet

## Description

Creates an ECS cluster backed by an EC2 Fleet using spot instances.

## Versions

|Release Tag|Description|
|---|---|
|v13|Initial release of module

## Variables

|Variable|Description|Default|
|---|---|---|
|aws_region|Region where the ECS cluster should be provisioned|n/a
|ecs_cluster_name|Name of the ECS cluster that is created|n/a
|instance_types|List of instance types to use in the fleet.  The first entry in the list is used as the instance type on the launch template|n/a
|ecs_instance_subnets|List of subnets where instances can be launched|n/a
|ecs_instance_key_name|Name of the SSH key to be used on the ECS instances|n/a
|ecs_instance_security_groups|List of security groups to place on the instances|n/a
|ecs_instance_role_policies|List of policies (ARNs) to attach to the instance profile placed on the ECS instances|n/a
|number_of_ecs_instances|How many instances should we provision|2
|spot_allocation_strategy|What spot allocation strategy should be used, can be 'diversified' or 'lowestPrice'|lowestPrice