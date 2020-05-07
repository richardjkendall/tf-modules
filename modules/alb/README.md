alb
======


Creates an ALB with a linked HTTPS listener.  Designed to be used with other modules which add target groups and listener rules.

Works with
------

* [ecs-haproxy](../ecs-haproxy/README.md)
* [atlantis-fargate](../atlantis-fargate/README.md)



Releases
------


There have been no releases yet for this module

Variables
------

|Name | Type | Description | Default Value|
--- | --- | --- | ---
`aws_region` | `string` | region where provisioning should happen | ``
`lb_subnets` | `list(string)` | subnets for the load balancer, should have public IP assignment possible + IGW attached | ``
`vpc_id` | `string` | ID for the VPC we will use | ``
`host_name` | `string` | host name for DNS entry created to point to load balancer | `haproxy-lb`
`root_domain` | `string` | root domain used for DNS entry created to point to load balancer | ``
`def_redir_scheme` | `string` | url scheme used for default redirect | `http`
`def_redir_host` | `string` | host used for default redirect | ``
`def_redir_path` | `string` | path for default redirect | `/`

