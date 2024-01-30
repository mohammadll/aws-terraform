## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.32.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.32.1 |


## Resources

| Name | Type |
|------|------|
| [aws_efs_backup_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/resources/efs_backup_policy) | resource |
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs_mount_target](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/resources/efs_mount_target) | resource |
| [aws_security_group.efs_mount_target_sg](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/resources/security_group) | resource |
| [aws_availability_zones.available_zones](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/data-sources/availability_zones) | data source |
| [aws_subnets.subnets_ids](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/data-sources/subnets) | data source |
| [aws_vpc.default_vpc](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_efs_backup_policy"></a> [create\_efs\_backup\_policy](#input\_create\_efs\_backup\_policy) | n/a | `bool` | `true` | no |
| <a name="input_create_efs_file_system"></a> [create\_efs\_file\_system](#input\_create\_efs\_file\_system) | n/a | `bool` | `true` | no |
| <a name="input_create_efs_mount_target"></a> [create\_efs\_mount\_target](#input\_create\_efs\_mount\_target) | n/a | `bool` | `true` | no |
| <a name="input_efs"></a> [efs](#input\_efs) | n/a | <pre>object({<br>    creation_token   = string<br>    encrypted        = bool<br>    performance_mode = string<br>    throughput_mode  = string<br>    backup_policy    = string<br>  })</pre> | <pre>{<br>  "backup_policy": "ENABLED",<br>  "creation_token": "terraform",<br>  "encrypted": true,<br>  "performance_mode": "generalPurpose",<br>  "throughput_mode": "elastic"<br>}</pre> | no |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | n/a | <pre>object({<br>    sg_ingress_from_port   = number<br>    sg_ingress_to_port     = number<br>    sg_ingress_protocol    = string<br>    sg_ingress_cidr_blocks = list(string)<br>    sg_egress_from_port    = number<br>    sg_egress_to_port      = number<br>    sg_egress_protocol     = string<br>    sg_egress_cidr_blocks  = list(string)<br>  })</pre> | <pre>{<br>  "sg_egress_cidr_blocks": [<br>    "0.0.0.0/0"<br>  ],<br>  "sg_egress_from_port": 0,<br>  "sg_egress_protocol": "-1",<br>  "sg_egress_to_port": 0,<br>  "sg_ingress_cidr_blocks": [<br>    "0.0.0.0/0"<br>  ],<br>  "sg_ingress_from_port": 2049,<br>  "sg_ingress_protocol": "tcp",<br>  "sg_ingress_to_port": 2049<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az_names"></a> [az\_names](#output\_az\_names) | n/a |
| <a name="output_default_vpc"></a> [default\_vpc](#output\_default\_vpc) | n/a |
| <a name="output_subnets_ids"></a> [subnets\_ids](#output\_subnets\_ids) | n/a |
