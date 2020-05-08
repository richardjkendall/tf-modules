
======




Releases
------

|Tag | Message | Commit|
--- | --- | ---
v48 | Merge branch 'master' of https://github.com/richardjkendall/tf-modules | `7a44f8`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`cluster_name` | `string` | name of cluster where service will run | ``
`service_name` | `string` | name of ECS service | ``
`service_registry_id` | `string` | ID for the AWS service discovery namespace we will use | ``
`service_registry_service_name` | `string` | name for service we will use in the service registry | ``
`users_table` | `string` | name of users table in dynamodb | `basicAuthUsers`
`auth_realm` | `string` | realm where users should exist | `dav`
`cache_dir` | `string` | dir where cache DB is held | `/tmp`
`cache_duration` | `string` | seconds that cache entries live for | `120`
`efs_filesystem_id` | `string` | ID for filesystem used to store data and config | ``
`gocd_data_directory` | `string` | directory on the filesystem which contains the godata directory | ``
`gocd_home_directory` | `string` | directory on the filesystem which contains the go user home directory | ``

