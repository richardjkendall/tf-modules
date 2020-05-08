ecs-agent-updater
======


Deploys a lambda function and associated cloudwatch trigger to periodically check and update the ECS agent on ECS container instances.

Depends on
------

* [lambda-function](../lambda-function/README.md)
* [lambda-schedule](../lambda-schedule/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v26 | added ecs-agent-updater module | `5d7d77`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`function_name` | `string` | name of lambda function | `EcsAgentUpdater`
`timeout` | `number` | how many seconds should the function be allowed to run for | `20`

