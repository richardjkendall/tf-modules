prom-grafana
======


Deploys an instance of prometheus and grafana running on ECS and connected to each other.  Uses EFS to store data.  Created to help monitor haproxy.

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
v27 | added prom-grafana module | `4662e19`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`cluster_name` | `not specified` | name of cluster where service will run | ``
`service_name` | `not specified` | name of ECS service | ``
`service_registry_id` | `not specified` | ID for the AWS service discovery namespace we will use | ``
`service_registry_service_name` | `not specified` | name for service we will use in the service registry | ``
`efs_filesystem_id` | `string` | ID for filesystem used to store data and config | ``
`prom_config_directory` | `string` | directory on the filesystem which contains the prometheus.yml file | ``
`prom_data_directory` | `string` | directory on the filesystem where the prometheus working directory is stored (/prometheus) | ``
`graf_data_directory` | `string` | directory on the filesystem where the grafana working directory is stored (/usr/lib/grafana) | ``

