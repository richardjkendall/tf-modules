
======




Releases
------

|Tag | Message | Commit|
--- | --- | ---
v34 | webdav-server: changes to support caching | 3d8c46
v31 | webdav-server: adding first version | f2a333

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
aws_region |  | region where provisioning should happen | 
cluster_name |  | name of cluster where service will run | 
service_name |  | name of ECS service | webdav
task_name |  | name of ECS container | webdav
tag_name | string | name of tag of webdav image to use | latest
service_registry_id |  | ID for the AWS service discovery namespace we will use | 
service_registry_service_name |  | name for service we will use in the service registry | _files._tcp
cpu | number | CPU units for the task | 128
memory | number | memory for the task | 128
efs_filesystem_id | string | ID for filesystem used to store files | 
dav_root_directory | string | directory on the filesystem which is the root of the dav filesystem | 
dav_lockdb_directory | string | directory on the filesystem which contains the dav lockdb | 
users_table | string | name of users table in dynamodb | basicAuthUsers
auth_realm | string | realm where users should exist | dav
cache_dir | string | dir where cache DB is held | /tmp
cache_duration | string | seconds that cache entries live for | 120

