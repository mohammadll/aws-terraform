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
| [aws_iam_group.developers_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_policy_attachment.group_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.ec2_get_console_screenshot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.iam_read_only_and_s3_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_user.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.group_membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_policy_attachment.user_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_policy.iam_read_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.ec2_get_console_screenshot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.iam_read_only_and_s3_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.instance_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_iam_ec2_get_console_screenshot_policy"></a> [create\_iam\_ec2\_get\_console\_screenshot\_policy](#input\_create\_iam\_ec2\_get\_console\_screenshot\_policy) | n/a | `bool` | `true` | no |
| <a name="input_create_iam_ec2_get_console_screenshot_policy_attachment"></a> [create\_iam\_ec2\_get\_console\_screenshot\_policy\_attachment](#input\_create\_iam\_ec2\_get\_console\_screenshot\_policy\_attachment) | n/a | `bool` | `true` | no |
| <a name="input_create_iam_group"></a> [create\_iam\_group](#input\_create\_iam\_group) | n/a | `bool` | `true` | no |
| <a name="input_create_iam_read_only_and_s3_full_access_policy"></a> [create\_iam\_read\_only\_and\_s3\_full\_access\_policy](#input\_create\_iam\_read\_only\_and\_s3\_full\_access\_policy) | n/a | `bool` | `true` | no |
| <a name="input_create_iam_read_only_and_s3_full_access_policy_attachment"></a> [create\_iam\_read\_only\_and\_s3\_full\_access\_policy\_attachment](#input\_create\_iam\_read\_only\_and\_s3\_full\_access\_policy\_attachment) | n/a | `bool` | `true` | no |
| <a name="input_create_iam_rule_with_policy"></a> [create\_iam\_rule\_with\_policy](#input\_create\_iam\_rule\_with\_policy) | n/a | `bool` | `true` | no |
| <a name="input_create_iam_user_group_membership"></a> [create\_iam\_user\_group\_membership](#input\_create\_iam\_user\_group\_membership) | n/a | `bool` | `true` | no |
| <a name="input_create_iam_users"></a> [create\_iam\_users](#input\_create\_iam\_users) | n/a | `bool` | `true` | no |
| <a name="input_ec2_get_console_screenshot"></a> [ec2\_get\_console\_screenshot](#input\_ec2\_get\_console\_screenshot) | n/a | <pre>map(object({<br>    actions   = list(string)<br>    resources = list(string)<br>    effect    = string<br>  }))</pre> | <pre>{<br>  "ec2_get_console_screenshot": {<br>    "actions": [<br>      "ec2:GetConsoleScreenshot"<br>    ],<br>    "effect": "Allow",<br>    "resources": [<br>      "*"<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_group_info"></a> [group\_info](#input\_group\_info) | n/a | `map(string)` | <pre>{<br>  "name": "developers",<br>  "path": "/"<br>}</pre> | no |
| <a name="input_iam_read_only_and_s3_full_access"></a> [iam\_read\_only\_and\_s3\_full\_access](#input\_iam\_read\_only\_and\_s3\_full\_access) | n/a | <pre>map(object({<br>    actions   = list(string)<br>    resources = list(string)<br>    effect    = string<br>  }))</pre> | <pre>{<br>  "iam_read_only": {<br>    "actions": [<br>      "iam:Get*",<br>      "iam:List*"<br>    ],<br>    "effect": "Allow",<br>    "resources": [<br>      "*"<br>    ]<br>  },<br>  "s3_full_access": {<br>    "actions": [<br>      "s3:*"<br>    ],<br>    "effect": "Allow",<br>    "resources": [<br>      "*"<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_users"></a> [users](#input\_users) | n/a | `list(map(string))` | <pre>[<br>  {<br>    "name": "jack",<br>    "path": "/"<br>  },<br>  {<br>    "name": "jones",<br>    "path": "/"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
