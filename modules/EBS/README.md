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
| [aws_ebs_snapshot.terraform-instance-volume-snapshot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_snapshot) | resource |
| [aws_ebs_volume.terraform-instance-volume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_instance.terraform-instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_volume_attachment.terraform-instance-volume-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_ami.amazon-linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_instance.terraform-instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_instance"></a> [create\_instance](#input\_create\_instance) | n/a | `bool` | `true` | no |
| <a name="input_create_instance_volume"></a> [create\_instance\_volume](#input\_create\_instance\_volume) | n/a | `bool` | `true` | no |
| <a name="input_create_instance_volume_attachement"></a> [create\_instance\_volume\_attachement](#input\_create\_instance\_volume\_attachement) | n/a | `bool` | `true` | no |
| <a name="input_create_instance_volume_snapshot"></a> [create\_instance\_volume\_snapshot](#input\_create\_instance\_volume\_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_ebs_attachment_device_name"></a> [ebs\_attachment\_device\_name](#input\_ebs\_attachment\_device\_name) | n/a | `string` | `"/dev/sdf"` | no |
| <a name="input_ebs_volume"></a> [ebs\_volume](#input\_ebs\_volume) | n/a | <pre>object({<br>    size       = number<br>    type       = string<br>    iops       = number<br>    throughput = number<br>  })</pre> | <pre>{<br>  "iops": 3000,<br>  "size": 2,<br>  "throughput": 125,<br>  "type": "gp3"<br>}</pre> | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t2.micro"` | no |

## Outputs

No outputs.
