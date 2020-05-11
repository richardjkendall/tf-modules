github-status-updater
======


Creates an SNS topic which you can attach to codepipeline instances to send notifications.  Notifications are converted to github status labels and posted to github.

Depends on
------

* [lambda-function](../lambda-function/README.md)



Works with
------

* [basic-cicd-ecs-pipeline](../basic-cicd-ecs-pipeline/README.md)
* [basic-cicd-s3-pipeline](../basic-cicd-s3-pipeline/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v60 | gsu: adding encryption for sqs queues | `97e200`
v56 | github-status-updater: added delivery day on first sqs queue, added variable def | `3ed544`
v54 | github-status-updater: adding output of sns topic arn | `2d0b49`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`gh_username` | `string` | github username | ``
`gh_access_token_parameter` | `string` | name of ssm parameter which contains the github access token | ``
`delay_seconds` | `number` | delay seconds to set on the sqs queue which picks up messages from sns topic | `10`
`encrypt` | `bool` | should encryption be enabled on SQS queues | `false`

Outputs
------

|Name | Description|
--- | ---
sns_topic_arn | 

