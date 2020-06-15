ecs-haproxy
======


Deploys a version of haproxy on ECS which monitors a service discovery namespace and dynamically adds/removes backends as they change.  Can either create its own ALB or work with an existing ALB.

Depends on
------

* [ecs-service](../ecs-service/README.md)



Works with
------

* [alb](../alb/README.md)



Releases
------

|Tag | Message | Commit|
--- | --- | ---
v67 | Merge branch 'master' of https://github.com/richardjkendall/tf-modules | `e522a91`
v50 | ecs-haproxy: adding support for lb rule priority | `b11f204`
v49 | ecs-haproxy,alb: start of work to allow multiple services to share a single ALB | `15f0922`
v23 | adding support for password secrets | `14006dd`
v22 | adding ability to change tag on haproxy image | `b02551c`
v17 | adding haproxy healthcheck changes | `d253a9b`
v16 | adding haproxy module and small changes to the ecs-service module to support it | `fcec2c0`

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `not specified` | region where provisioning should happen | ``
`cluster_name` | `not specified` | name of cluster where service will run | ``
`service_name` | `not specified` | name of ECS service | `haproxy`
`task_name` | `not specified` | name of ECS container | `haproxy`
`tag_name` | `string` | name of tag of haproxy image to use | `latest`
`service_registry_id` | `not specified` | ID for the AWS service discovery namespace we will use | ``
`service_registry_service_name` | `not specified` | name for service we will use in the service registry | `haproxy-do-not-use`
`cpu` | `number` | CPU units for the task | `128`
`memory` | `number` | memory for the task | `256`
`default_domain` | `not specified` | domain where unmatched requests are redirected | ``
`namespace_map` | `list(object({domainname=string,namespace=string}))` | map of namespaces to domains | ``
`refresh_rate` | `not specified` | now often (in seconds) service changes be found and applied | `30`
`prom_password_ssm_secret` | `string` | name of ssm secret which contains prom metrics endpoint password | ``
`stats_password_ssm_secret` | `string` | name of ssm secret which contains stats endpoint password | ``
`lb_subnets` | `list(string)` | subnets for the load balancer, should have public IP assignment possible + IGW attached | `[]`
`vpc_id` | `not specified` | ID for the VPC we will use | ``
`listener_cert_arn` | `not specified` | arn for the listener certifcate the load balancer will use | ``
`host_name` | `not specified` | host name for DNS entry created to point to load balancer | `haproxy-lb`
`root_domain` | `not specified` | root domain used for DNS entry created to point to load balancer | ``
`number_of_tasks` | `number` | number of tasks to spawn for haproxy | `2`
`create_lb` | `bool` | should the module create a load balancer or link to an existing one | `true`
`listener_arn` | `string` | arn of existing load balancer listener if linking to an existing lb | ``
`rule_priority` | `number` | priority used for rule on existing alb | `100`

