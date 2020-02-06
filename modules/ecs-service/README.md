# ECS Service

## Description

Creates a service running on an ECS cluster along with the definitions for the tasks which make up the service.

## Versions

|Release Tag|Description|
|---|---|
|v16|Initial release of module|
|v21|Adds support for the healthcheck parameter|
|v24|Fix for secret support (added execution role to enable SSM secret access)|
|v25|Added support for EFS volumes|


## Variables

|Variable|Description|Default|Version
|---|---|---|---|
|aws_region|Region where the ECS cluster should be provisioned|n/a
|ecs_cluster_name|Name of the ECS cluster where the service will run|n/a
|service_name|Name of the ECS service|n/a
|task_name|Name of the ECS task|n/a
|service_registry_id|ID of the service registry used for the service|n/a
|service_registry_service_name|Name to give the service in the registry|n/a
|image|Name of the image to be used|n/a
|cpu|CPU units for the task (1 CPU=1024)|128
|memory|MB of memory for the task|256
|port_mappings|List of port mappings (see below for more info)|n/a
|secrets|List of environment variables to be sourced from secrets (see below for more info)|empty list|v24
|environment|List of non-secret environment variables (see below for more info)|empty list
|healthcheck|Definition of the healthcheck for the container|none|v21
|network_mode|What network mode should be used for the container|bridge
|number_of_tasks|How many tasks should the service run|2
|load_balancer|Details of the load balancer to attach to the service|none
|efs_volumes|List of EFS volumes to be enabled for task|empty list|v25
|mount_points|List of mount points for the task definition|empty list|v25

### port_mappings
List of objects, each one with the following fields.

|Field|Type|Purpose
|---|---|---|
|containerPort|number|Number of port exposed by container
|hostPort|number|Number of port used on host (set to 0 for automatic)
|protocol|string|Either "tcp" or "udp"

### secrets
List of objects, each one with the following fields.

|Field|Type|Purpose
|---|---|---|
|name|string|Name of environment variable exposed to running containers
|valueFrom|string|Name of SSM parameter that the secret should be populated from

### environment
List of objects, each one with the following fields.

|Field|Type|Purpose
|---|---|---|
|name|string|Name of environment variable exposed to running containers
|value|string|Value of environment variable

### healthcheck
A single object, with the following fields

|Field|Type|Purpose
|---|---|---|
|command|list(string)|List of commands to run as part of health check
|interval|number|How often (in seconds) to run the health check
|timeout|number|How long (in seconds) to wait for the health check to return successful before failing|
|retries|number|How many times should the health check be retried before it is considered failed|
|startPeriod|number|Once the task starts, how long (in seconds) should the system wait before commencing health checks

### load_balancer
A single object, with the following fields

|Field|Type|Purpose
|---|---|---|
|target_group_arn|string|ARN of the target group to use for task instances
|container_name|string|Name of the container (in the task definition) which should be exposed to the target group
|container_port|number|Port number on the container which should be exposed to the target group

### efs_volumes
A list of objects, each with the following fields

|Field|Type|Purpose
|---|---|---|
|name|string|Name for this volume (used in the task definition)
|fileSystemId|string|ID for the EFS filesystem we are using
|rootDirectory|string|The directory on the EFS filesystem which should be the 'root' for the mount connected to the container

### mount_points
A list of objects, each with the following fields

|Field|Type|Purpose
|---|---|---|
|sourceVolume|string|Should match to one of the names of the efs_volumes
|containerPath|string|Path on the container where the volume should be mounted
|readOnly|bool|Should the filesystem be read-only (true) or writable (false)