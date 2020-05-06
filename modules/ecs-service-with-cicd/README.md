ecs-service-with-cicd
======


Builds an ECS service connected to a github reposistory and redeploys the service each time the code changes.

Releases
------

|Tag | Message | Commit|
--- | --- | ---
v57 | ecs-service-with-cicd: adding support for notifications | dea61c
v18 | adding ECS pipeline and ECS service with pipeline | 53a5c3

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
aws_region |  | region where provisioning should happen | 
cluster_name |  | name of cluster where service will run | 
service_name |  | name of ECS service | 
task_name |  | name of ECS container | 
image_repo |  | name of image repo (ECR repo) | 
service_registry_id |  | ID for the AWS service discovery namespace we will use | 
service_registry_service_name |  | name for service we will use in the service registry | 
image |  | image task will use | 
cpu | number | CPU units for the task | 128
memory | number | memory for the task | 256
port_mappings | list(object({containerPort=number,hostPort=number,protocol=string})) | list of port mappings for the task | 
secrets | list(object({name=string,valueFrom=string})) | environment variables from secrets | []
environment | list(object({name=string,value=string})) | non scret environment variables | []
network_mode |  | network mode to use for tasks | bridge
number_of_tasks | number | number of tasks to spawn for service | 2
load_balancer | object({container_name=string,container_port=number,target_group_arn=string}) | application load balancer associated with the service | ERROR: cannot convert!
gh_username |  | GitHub username used to access your site source code repo | 
gh_secret_sm_param_name |  | name of SSM parameter where GitHub webhook secret is stored | 
gh_token_sm_param_name |  | name of SSM parameter where the GitHub Oauth token is stored | 
gh_repo |  | name of repo containing site source and buildspec.yml file | 
gh_branch |  | branch of git repo to use for changes | master
send_notifications | bool | should pipeline notifications be sent | false
sns_topic_for_notifications | string | arn for sns topic to send notifications to | 
notifications_to_send | list(string) | which notifications should we send, for values see here https://docs.aws.amazon.com/codestar-notifications/latest/userguide/concepts.html#concepts-api | [codepipeline-pipeline-pipeline-execution-failed, codepipeline-pipeline-pipeline-execution-canceled, codepipeline-pipeline-pipeline-execution-started, codepipeline-pipeline-pipeline-execution-resumed, codepipeline-pipeline-pipeline-execution-succeeded, codepipeline-pipeline-pipeline-execution-superseded]

