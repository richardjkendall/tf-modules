simple-cf-stats
======


Deploys a simple service based on webalizer to produce stats for AWS Cloudfront distributions

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
`service_name` | `string` | name of ECS service | ``
`service_registry_id` | `string` | ID for the AWS service discovery namespace we will use | ``
`service_registry_service_name` | `string` | name for service we will use in the service registry | ``
`users_table` | `string` | name of users table in dynamodb | `basicAuthUsers`
`auth_realm` | `string` | realm where users should exist | `dav`
`cache_dir` | `string` | dir where cache DB is held | `/tmp`
`cache_duration` | `string` | seconds that cache entries live for | `120`
`log_bucket` | `string` | s3 bucket where cloudfront distribution logs are stored | ``
`log_prefix` | `string` | s3 prefix for the cloudfront distribution logs | ``
`hostname` | `string` | hostname of the site hosted on cloudfront | ``
`filter` | `list(object({dateFragment=string}))` | filter for S3 logs used by the tool | `[]`

