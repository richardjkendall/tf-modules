# ECS HAproxy

## Description

Deploys a service-discovery aware version of HAproxy along with an application load balancer for SSL offload.  It will automatically add (and remove) backends and front-end routing rules as new services are deployed and un-deployed.

The code for the haproxy extension is here https://github.com/richardjkendall/haproxy

## Versions

|Release Tag|Description|
|---|---|
|v24|Fixes and support for setting passwords via secrets, this is the only version that will work|


## Variables

|Variable|Description|Default|Version
|---|---|---|---|
|aws_region|Region where the ECS cluster should be provisioned|n/a
|cluster_name|Name of the ECS cluster where the service will run|n/a
|service_name|Name of the ECS service which will run|haproxy
|task_name|Name of the task definition which will run|haproxy
|tag_name|Which tag to use when picking up the image from the docker repository|latest
|service_registry_id|ID for the service registry instance to use to register the haproxy service|n/a
|service_registry_service_name|Name of the service to use in the service registry (see note)|haproxy-do-not-use|
|cpu|CPU units for the task|128
|memory|MB of memory for the task|256
|default_domain|Domain to send unrouted requests to (requests which don't match any of the frontend rules)|n/a
|namespace_map|Mapping of service discovery namespaces to domain roots (explained below)|n/a
|refresh_rate|How often the services should be refreshed (in seconds)|30
|prom_password_ssm_secret|Name of the SSM parameter which contains the password used to secure the Prometheus metrics end-point|n/a
|stats_password_ssm_secret|Name of the SSM parameter which contains the password used to secure the HAproxy stats pages|n/a
|lb_subnets|List of subnet IDs to use for the application load balancer|n/a
|vpc_id|VPC ID for the VPC containing the subnets|n/a
|listener_cert_arn|ARN for the certificate which will be attached to the HTTPS listener on the ALB|n/a
|host_name|Name of the host for the ALB endpoint e.g. for alb.example.com this would be 'alb'|n/a
|root_domain|Name of the root domain for the ALB endpoint e.g. for alb.example.com this would be 'example.com'.  This must be a Route53 managed zone.|n/a
|number_of_tasks|How many tasks should be deployed|2

Note: The adding of the haproxy instances to the service registry is to help find them for purposes of scraping metrics and checking status.  That's why the default name for the service is 'haproxy-do-not-use' - no traffic should be sent to the service.

### namespace_map
List of objects, each with the following fields:

|Field|Type|Purpose
|---|---|---|
|namespace|string|ID for the namespace which should be mapped
|domainname|string|Name of the root of the domain name which should be used for the services in the namespace e.g. example.com