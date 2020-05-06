api-lambda
======


Exposes a python lambda function as an API using API gateway.  Lambda function code must be in a public github repo.

Releases
------


There have been no releases yet for this module

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
aws_region | string | region where provisioning should happen | 
api_name | string | name of api | 
function_name | string | name of lambda function | 
handler | string | name of handler function | 
runtime | string | rumtime for the lambda function | python3.8
timeout | number | how many seconds should the function be allowed to run for | 20
memory | number | how many MB of memory should be allocated to the function | 128
code_repository | string | URL for code to be deployed for the API | 
http_method | string | HTTP method for the API | ANY
stage_name | string | name of the API stage to be deployed | prod

