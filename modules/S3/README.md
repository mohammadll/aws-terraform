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
| [aws_s3_bucket.terraform_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.lifecycle_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.allow_access_to_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.terraform_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.bucket_static_website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_object.terraform_bucket_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_iam_policy_document.s3_terraform_bucket_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_objects"></a> [bucket\_objects](#input\_bucket\_objects) | n/a | `list(map(string))` | <pre>[<br>  {<br>    "content_type": "image/jpg",<br>    "key": "coffee.jpg",<br>    "source": "S3/coffee.jpg"<br>  },<br>  {<br>    "content_type": "image/jpg",<br>    "key": "beach.jpg",<br>    "source": "S3/beach.jpg"<br>  },<br>  {<br>    "content_type": "text/html",<br>    "key": "index.html",<br>    "source": "S3/index.html"<br>  }<br>]</pre> | no |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | n/a | <pre>object({<br>    effect                = string<br>    actions               = list(string)<br>    principal_type        = string<br>    principal_identifiers = list(string)<br><br>  })</pre> | <pre>{<br>  "actions": [<br>    "s3:GetObject"<br>  ],<br>  "effect": "Allow",<br>  "principal_identifiers": [<br>    "*"<br>  ],<br>  "principal_type": "AWS"<br>}</pre> | no |
| <a name="input_bucket_versioning"></a> [bucket\_versioning](#input\_bucket\_versioning) | n/a | `string` | `"Enabled"` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | n/a | `bool` | `true` | no |
| <a name="input_create_s3_bucket_lifecycle_configuration"></a> [create\_s3\_bucket\_lifecycle\_configuration](#input\_create\_s3\_bucket\_lifecycle\_configuration) | n/a | `bool` | `true` | no |
| <a name="input_create_s3_bucket_policy"></a> [create\_s3\_bucket\_policy](#input\_create\_s3\_bucket\_policy) | n/a | `bool` | `true` | no |
| <a name="input_create_s3_bucket_public_access_block"></a> [create\_s3\_bucket\_public\_access\_block](#input\_create\_s3\_bucket\_public\_access\_block) | n/a | `bool` | `true` | no |
| <a name="input_create_s3_bucket_versioning"></a> [create\_s3\_bucket\_versioning](#input\_create\_s3\_bucket\_versioning) | n/a | `bool` | `true` | no |
| <a name="input_create_s3_bucket_website_configuration"></a> [create\_s3\_bucket\_website\_configuration](#input\_create\_s3\_bucket\_website\_configuration) | n/a | `bool` | `true` | no |
| <a name="input_create_s3_object"></a> [create\_s3\_object](#input\_create\_s3\_object) | n/a | `bool` | `true` | no |
| <a name="input_noncurrent_days_expiration"></a> [noncurrent\_days\_expiration](#input\_noncurrent\_days\_expiration) | n/a | `number` | `90` | no |
| <a name="input_noncurrent_transition_lifecycle_rules"></a> [noncurrent\_transition\_lifecycle\_rules](#input\_noncurrent\_transition\_lifecycle\_rules) | n/a | <pre>map(object({<br>    noncurrent_days = number<br>    storage_class = string<br>  }))</pre> | <pre>{<br>  "transition_to_GLACIER": {<br>    "noncurrent_days": 60,<br>    "storage_class": "GLACIER"<br>  },<br>  "transition_to_IA": {<br>    "noncurrent_days": 30,<br>    "storage_class": "STANDARD_IA"<br>  }<br>}</pre> | no |
| <a name="input_s3_bucket_force_destroy"></a> [s3\_bucket\_force\_destroy](#input\_s3\_bucket\_force\_destroy) | n/a | `bool` | `true` | no |
| <a name="input_s3_bucket_tags"></a> [s3\_bucket\_tags](#input\_s3\_bucket\_tags) | n/a | `map(string)` | <pre>{<br>  "environment": "dev",<br>  "name": "s3-terraform-bucket-demo"<br>}</pre> | no |

## Outputs

No outputs.
