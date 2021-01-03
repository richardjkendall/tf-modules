basicauth-user-manager
======


Deploys a service to manage users in a dynamodb table which is used by the basicauth reverse proxy module.

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
`service_name` | `string` | name of ECS service | `user-manager`
`service_registry_id` | `string` | ID for the AWS service discovery namespace we will use | ``
`service_registry_service_name` | `string` | name for service we will use in the service registry | ``
`create_table` | `bool` | should we create a new dynamodb table to contain managed users? | `false`
`ddb_table` | `string` | name of the ddb table to manage | `basicAuthUsers`
`admin_realm` | `string` | name of the realm used to control access to the user manager app | `usermanager`
`admin_user` | `string` | name of the default admin user that is created | `admin`
`admin_password_ssm_secret_name` | `string` | name of the ssm secret which contains the password for the default admin user that is created | ``
`admin_salt` | `string` | should we salt the default admin password (yes or no) | `yes`

