lambda-schedule
======


Creates a schedule for triggering a lambda function.

Works with
------

* [lambda-function](../lambda-function/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v26 | added ecs-agent-updater module | `5d7d779`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`function_name` | `string` | name of lambda function to be scheduled | ``
`schedule_expression` | `string` | schedule for trigger | `rate(12 hours)`

