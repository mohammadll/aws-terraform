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
| [aws_ami_from_instance.my_own_ami](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/resources/ami_from_instance) | resource |
| [aws_instance.terraform](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/resources/instance) | resource |
| [aws_ami.amazon-linux](https://registry.terraform.io/providers/hashicorp/aws/5.32.1/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_ami_from_instance"></a> [create\_ami\_from\_instance](#input\_create\_ami\_from\_instance) | n/a | `bool` | `true` | no |
| <a name="input_create_instance"></a> [create\_instance](#input\_create\_instance) | n/a | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t2.micro"` | no |

## Outputs

No outputs.
