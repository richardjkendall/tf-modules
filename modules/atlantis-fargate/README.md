atlantis-fargate
======


Deploys a fargate task and service running atlantis (https://www.runatlantis.io).  Can create its own ALB or work with the ALB module to add rules to an existing ALB.

Works with
------

* [alb](../alb/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v67 | Merge branch 'master' of https://github.com/richardjkendall/tf-modules | `e522a91`
v53 | atlantis-fargate: supports external alb | `f49337e`
v33 | atlantis-fargate: adding support for custom deploy IAM policies | `e372ffa`
v32 | atlantis-fargate: adding create instance profile permission | `08692b6`
v15 | fixed permissions on atlantis deployer role | `c94379c`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`ecs_cluster_name` | `string` | name of the ECS cluster created | `atlantis`
`cpu` | `number` | CPU units for the task | `256`
`memory` | `number` | memory for the task | `512`
`task_def_name` | `string` | name of the task definition created for atlantis | `atlantis`
`root_domain` | `string` | root domain where this is provisioned e.g. example.com, you should have a Route53 zone for this domain in your aws account | ``
`host_name` | `string` | host name used for atlantis e.g. [atlantis].example.com | `atlantis`
`gh_user` | `string` | GitHub username used to access your repos (and dependencies) | ``
`gh_token_secret_name` | `string` | name of SSM parameter where the GitHub Oauth token is stored | ``
`gh_repo_whitelist` | `string` | what repos can be picked up by atlantis e.g. github.com/blah/aws* | ``
`gh_webhook_secret_name` | `string` | name of SSM parameter where GitHub webhook secret is stored | ``
`vpc_id` | `string` | ID for the VPC we will use | ``
`allowed_ips` | `list(string)` | list of ip ranges allowed to access the atlantis endpoint, only used if the GH API does not return a list | `[0.0.0.0/0]`
`lb_subnets` | `list(string)` | subnets for the load balancer, should have public IP assignment possible + IGW attached | `[]`
`task_subnets` | `list(string)` | subnets where the task will launch, can be the same as lb_subnets, can be different if you have private subnets for applications.  Needs internet access either via IGW, NAT G/W or NAT instance. | ``
`deployment_role_policies` | `list(string)` | list of arns of custom deployment role policies to be added | `[]`
`create_lb` | `bool` | should the module create a load balancer or link to an existing one | `true`
`lb_arn` | `string` | arn of existing load balancer if linking to an existing lb | ``
`listener_arn` | `string` | arn of existing load balancer listener if linking to an existing lb | ``
`rule_priority` | `number` | priority used for rule on existing alb | `100`
`lb_sec_group_id` | `string` | id of security group attached to existing alb | ``

