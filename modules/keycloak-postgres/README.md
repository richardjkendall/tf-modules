
======




Releases
------

|Tag | Message | Commit|
--- | --- | ---
v29 | keycloak-postgres: added module | 19c19c

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
aws_region |  | region where provisioning should happen | 
cluster_name |  | name of cluster where service will run | 
service_name |  | name of ECS service | 
service_registry_id |  | ID for the AWS service discovery namespace we will use | 
service_registry_service_name |  | name for service we will use in the service registry | 
efs_filesystem_id | string | ID for filesystem used to store data and config | 
postgres_data_directory | string | directory on the filesystem which contains the postgres database | 
keycloak_admin_user_password_secret | string | name of secret containing keycloak admin user password | 
postgres_password_secret | string | name of secret containing password for postgres | 

