people-detect-lambda
======


Deploys a lambda function which when triggered by S3 ObjectCreated notifications scans the images for people and saves updated image files with bounding boxes drawn around the people.

Depends on
------

* [lambda-function-with-layer](../lambda-function-with-layer/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v114 | people-detect-lambda: add backend and fix docs | `cd582af`
v113 | lambda/people detect work | `0aa3e5b`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`image_source_bucket` | `string` | S3 bucket which acts as the source for the images | ``
`image_output_bucket` | `string` | S3 bucket which acts as the target for the images | ``
`image_output_key` | `string` | Key to use as prefix for images which are sent to the output bucket | ``
`input_rules` | `list(object({prefix=string,suffix=string}))` | List of rules that can trigger the lambda function to process images | ``

