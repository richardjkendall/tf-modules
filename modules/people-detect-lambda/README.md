
======




Releases
------


There have been no releases yet for this module

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`image_source_bucket` | `string` | S3 bucket which acts as the source for the images | ``
`image_output_bucket` | `string` | S3 bucket which acts as the target for the images | ``
`image_output_key` | `string` | Key to use as prefix for images which are sent to the output bucket | ``
`input_rules` | `list(object({prefix=string,suffix=string}))` | List of rules that can trigger the lambda function to process images | ``

