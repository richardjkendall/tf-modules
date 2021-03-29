s3-bucket
======


Creates an S3 bucket with some sensible defaults

Releases
------


There have been no releases yet for this module

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`encrypt_bucket` | `bool` | Should we encrypt the bucket contents, defaults to true | `true`
`bucket_prefix` | `string` | Name to prefix the bucket with | ``
`access_log_bucket` | `string` | Name of the bucket to put access logs in, if blank access logging is disabled | ``
`access_log_prefix` | `string` | Prefix for access logging if enabled | ``

Outputs
------

|Name | Description|
--- | ---
s3_bucket_name | The name of the bucket that was created
s3_bucket_arn | The arn of the bucket that was created

