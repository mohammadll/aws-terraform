## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.20 |


## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.autoscaling_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.autoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_key_pair.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_configuration.template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.load_balancer_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.elb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazon-linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnets.subnets_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_group"></a> [autoscaling\_group](#input\_autoscaling\_group) | n/a | <pre>object({<br>    name = string<br>    max_size = number<br>    min_size = number<br>    cooldown = number<br>    health_check_grace_period = number<br>    health_check_type = string<br>    desired_capacity = number<br>    force_delete = bool<br>  })</pre> | <pre>{<br>  "cooldown": 400,<br>  "desired_capacity": 1,<br>  "force_delete": true,<br>  "health_check_grace_period": 400,<br>  "health_check_type": "ELB",<br>  "max_size": 1,<br>  "min_size": 1,<br>  "name": "terraform_autoscaling_group"<br>}</pre> | no |
| <a name="input_autoscaling_policy"></a> [autoscaling\_policy](#input\_autoscaling\_policy) | n/a | <pre>object({<br>    autoscaling_policy_name = string<br>    policy_type = string<br>    predefined_metric_type = string<br>    target_value = number<br>  })</pre> | <pre>{<br>  "autoscaling_policy_name": "terraform_autoscaling_policy",<br>  "policy_type": "TargetTrackingScaling",<br>  "predefined_metric_type": "ASGAverageCPUUtilization",<br>  "target_value": 40<br>}</pre> | no |
| <a name="input_create_autoscaling_attachment"></a> [create\_autoscaling\_attachment](#input\_create\_autoscaling\_attachment) | n/a | `bool` | `true` | no |
| <a name="input_create_autoscaling_group"></a> [create\_autoscaling\_group](#input\_create\_autoscaling\_group) | n/a | `bool` | `true` | no |
| <a name="input_create_autoscaling_policy"></a> [create\_autoscaling\_policy](#input\_create\_autoscaling\_policy) | n/a | `bool` | `true` | no |
| <a name="input_create_launch_configuration"></a> [create\_launch\_configuration](#input\_create\_launch\_configuration) | n/a | `bool` | `true` | no |
| <a name="input_create_listener_rule"></a> [create\_listener\_rule](#input\_create\_listener\_rule) | n/a | `bool` | `true` | no |
| <a name="input_create_load_balancer"></a> [create\_load\_balancer](#input\_create\_load\_balancer) | n/a | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | n/a | `bool` | `true` | no |
| <a name="input_create_target_group"></a> [create\_target\_group](#input\_create\_target\_group) | n/a | `bool` | `true` | no |
| <a name="input_cross_zone_load_balancing"></a> [cross\_zone\_load\_balancing](#input\_cross\_zone\_load\_balancing) | n/a | `bool` | `true` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | n/a | `bool` | `false` | no |
| <a name="input_lc_instance_type"></a> [lc\_instance\_type](#input\_lc\_instance\_type) | n/a | `string` | `"t2.micro"` | no |
| <a name="input_lc_name_prefix"></a> [lc\_name\_prefix](#input\_lc\_name\_prefix) | n/a | `string` | `"terraform-lc-"` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | n/a | <pre>object({<br>    name   = string<br>    scheme = bool<br>    type   = string<br>  })</pre> | <pre>{<br>  "name": "terraform-load-balancer",<br>  "scheme": false,<br>  "type": "application"<br>}</pre> | no |
| <a name="input_load_balancer_listener"></a> [load\_balancer\_listener](#input\_load\_balancer\_listener) | n/a | `map(string)` | <pre>{<br>  "port": "80",<br>  "protocol": "HTTP"<br>}</pre> | no |
| <a name="input_rule_priority"></a> [rule\_priority](#input\_rule\_priority) | n/a | `number` | `5` | no |
| <a name="input_security_ingress_rules"></a> [security\_ingress\_rules](#input\_security\_ingress\_rules) | n/a | <pre>map(object({<br>    description = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>{<br>  "http_rule": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow Traffic from HTTP",<br>    "from_port": 80,<br>    "protocol": "tcp",<br>    "to_port": 80<br>  }<br>}</pre> | no |
| <a name="input_stickiness"></a> [stickiness](#input\_stickiness) | n/a | <pre>object({<br>    type            = string<br>    enabled         = bool<br>    cookie_name     = string<br>    cookie_duration = number<br>  })</pre> | <pre>{<br>  "cookie_duration": 3600,<br>  "cookie_name": "AWSTERRAFORM",<br>  "enabled": true,<br>  "type": "lb_cookie"<br>}</pre> | no |
| <a name="input_target_group"></a> [target\_group](#input\_target\_group) | n/a | <pre>object({<br>    name             = string<br>    port             = number<br>    type             = string<br>    protocol         = string<br>    protocol_version = string<br>  })</pre> | <pre>{<br>  "name": "terraform-target-group",<br>  "port": 80,<br>  "protocol": "HTTP",<br>  "protocol_version": "HTTP1",<br>  "type": "instance"<br>}</pre> | no |

## Outputs

No outputs.
