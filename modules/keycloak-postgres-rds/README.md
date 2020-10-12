keycloak-postgres
======


Deploys an instance of JBoss Keycloak backed by a postgres database on an ECS cluster

Depends on
------

* [ecs-service](../ecs-service/README.md)
* [postgres-rds](../postgres-rds/README.md)



Works with
------

* [ecs-haproxy](../ecs-haproxy/README.md)



Releases
------


There have been no releases yet for this module

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
`keycloak_admin_user_password_secret` | `string` | name of secret containing keycloak admin user password | ``
`postgres_password_secret` | `string` | name of secret containing password for postgres | ``
`client_sec_group` | `string` | security group for the instances which should have access to the database | ``
`keycloak_image` | `string` | should we use a different image for keycloak | `jboss/keycloak`

