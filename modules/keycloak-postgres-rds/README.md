keycloak-postgres-rds
======


Deploys an instance of JBoss Keycloak backed by a postgres database running on RDS

Depends on
------

* [ecs-service](../ecs-service/README.md)
* [postgres-rds](../postgres-rds/README.md)



Works with
------

* [ecs-haproxy](../ecs-haproxy/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v87 | keycloak-postgres-*: changes to support setting increased memory for keycloak | `c9af916`
v77 | keycloak-postgres-rds: new module and supporting modules added | `b0c0643`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`vpc_id` | `string` | vpc where DB will be provisioned | ``
`cluster_name` | `not specified` | name of cluster where service will run | ``
`service_name` | `not specified` | name of ECS service | ``
`service_registry_id` | `not specified` | ID for the AWS service discovery namespace we will use | ``
`service_registry_service_name` | `not specified` | name for service we will use in the service registry | ``
`cpu` | `number` | cpu allocation to the keycloak task | `512`
`memory` | `number` | memory allocation to the keycloak task | `512`
`keycloak_admin_user_password_secret` | `string` | name of secret containing keycloak admin user password | ``
`postgres_password_secret` | `string` | name of secret containing password for postgres | ``
`client_sec_group` | `string` | security group for the instances which should have access to the database | ``
`keycloak_image` | `string` | should we use a different image for keycloak | `jboss/keycloak`
`db_storage_size` | `number` | number of GB of storage which is allocated | `10`
`db_storage_type` | `string` | type of storage used for database | `gp2`
`db_instance_class` | `string` | what class of underlying instances should be used | `db.t3.small`
`db_multi_az` | `bool` | should the database be deployed across multiple AZs | `false`
`java_opts` | `string` | options to pass to the JVM | ``

