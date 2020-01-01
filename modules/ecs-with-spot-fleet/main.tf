provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_ssm_parameter" "ecs_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.ecs_cluster_name}"
  
}

data "aws_iam_policy_document" "servicediscovery_policy_document" {
  statement {
    sid = "1"

    actions = [
      "servicediscovery:DeregisterInstance",
      "servicediscovery:Get*",
      "servicediscovery:List*",
      "servicediscovery:RegisterInstance",
      "servicediscovery:UpdateInstanceCustomHealthStatus"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "servicediscovery_policy" {
  policy = "${data.aws_iam_policy_document.servicediscovery_policy_document.json}"
}

resource "aws_iam_role" "ecs_instance_role" {
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_ecs_service_policy" {
  role        = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "attach_servicediscovery_policy" {
  role        = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn  = "${aws_iam_policy.servicediscovery_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "user_policies" {
  count       = length(var.ecs_instance_role_policies)

  role        = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn  = element(var.ecs_instance_role_policies, count.index)
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  role = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_launch_template" "ecs_ec2_launch_template" {
  name_prefix             = "${var.ecs_cluster_name}-lt-"
  instance_type           = element(var.instance_types, 0)
  key_name                = "${var.ecs_instance_key_name}"
  vpc_security_group_ids  = var.ecs_instance_security_groups
  image_id                = "${data.aws_ssm_parameter.ecs_ami_id.value}"

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    cluster_name  = "${var.ecs_cluster_name}"
    region        = "${var.aws_region}"
  }))

  iam_instance_profile {
    arn = "${aws_iam_instance_profile.ecs_instance_profile.arn}"
  }
}

resource "aws_ec2_fleet" "ecs_fleet" {
  depends_on = [aws_ecs_cluster.cluster]

  launch_template_config {
    launch_template_specification {
      launch_template_id  = "${aws_launch_template.ecs_ec2_launch_template.id}"
      version             = "${aws_launch_template.ecs_ec2_launch_template.latest_version}"
    }

    /*dynamic "override" {
      for_each = var.instance_types

      content {
        instance_type = override.value
      }
    }*/

    dynamic "override" {
      for_each = var.ecs_instance_subnets

      content {
        subnet_id = override.value
      }
    }

  }

  target_capacity_specification {
    default_target_capacity_type = "spot"
    total_target_capacity = var.number_of_ecs_instances
  }

  spot_options {
    allocation_strategy = "${var.spot_allocation_strategy}"
  }
}

