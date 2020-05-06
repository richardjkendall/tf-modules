
======




Releases
------

|Tag | Message | Commit|
--- | --- | ---
v37 | web-jumphost-basic: added task role to access dynamodb table | d06f26
v35 | web-jumphost-basic: adding jumphost with basic auth support | 384955

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
aws_region | string | region where provisioning should happen | 
cluster_name | string | name of cluster where service will run | 
service_name | string | name of ECS service | 
service_registry_id | string | ID for the AWS service discovery namespace we will use | 
service_registry_service_name | string | name for service we will use in the service registry | 
read_only_filesystem | bool | should the filesytem be read only | false
efs_volumes | list(object({fileSystemId=string,name=string,rootDirectory=string})) | volumes for the task | []
mount_points | list(object({containerPath=string,readOnly=bool,sourceVolume=string})) | mount points for the task definition | []
users_table | string | name of users table in dynamodb | basicAuthUsers
auth_realm | string | realm where users should exist | dav
cache_dir | string | dir where cache DB is held | /tmp
cache_duration | string | seconds that cache entries live for | 120

