locals {
  create_s3_bucket = var.create_s3_bucket
  create_s3_bucket_public_access_block = var.create_s3_bucket_public_access_block
  create_s3_bucket_policy = var.create_s3_bucket_policy
  create_s3_bucket_versioning = var.create_s3_bucket_versioning
  create_s3_bucket_lifecycle_configuration = var.create_s3_bucket_lifecycle_configuration
  create_s3_object = var.create_s3_object
  create_s3_bucket_website_configuration = var.create_s3_bucket_website_configuration
}

resource "aws_s3_bucket" "terraform_bucket" {
  count = local.create_s3_bucket ? 1 : 0
  bucket = var.s3_bucket_tags["name"]
  force_destroy = var.s3_bucket_force_destroy

  tags = {
    Name        = var.s3_bucket_tags["name"]
    Environment = var.s3_bucket_tags["environment"]
  }
}

data "aws_iam_policy_document" "s3_terraform_bucket_access_policy" {

  count = local.create_s3_bucket ? 1 : 0

  statement {

    effect = var.bucket_policy["effect"]

    principals {
      type        = var.bucket_policy["principal_type"]
      identifiers = var.bucket_policy["principal_identifiers"]
    }

    actions = var.bucket_policy["actions"]

    resources = [
      "${aws_s3_bucket.terraform_bucket[0].arn}/*",
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  count = local.create_s3_bucket && local.create_s3_bucket_public_access_block ? 1 : 0
  bucket = aws_s3_bucket.terraform_bucket[0].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_access_to_bucket" {
  count = local.create_s3_bucket && local.create_s3_bucket_public_access_block && local.create_s3_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.terraform_bucket[0].id
  policy = data.aws_iam_policy_document.s3_terraform_bucket_access_policy[0].json
  depends_on = [
    aws_s3_bucket_public_access_block.public_access_block[0]
  ]
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  count = local.create_s3_bucket && local.create_s3_bucket_versioning ? 1 : 0
  bucket = aws_s3_bucket.terraform_bucket[0].id
  versioning_configuration {
    status = var.bucket_versioning
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  count = local.create_s3_bucket && local.create_s3_bucket_versioning && local.create_s3_bucket_lifecycle_configuration ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.terraform_bucket_versioning[0]]

  bucket = aws_s3_bucket.terraform_bucket[0].id

  rule {
    id = "terraform_bucket_lifecycle"

    filter {
      and {
        tags = {
          Env = var.s3_bucket_tags["environment"]
        }
      }
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_days_expiration
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.noncurrent_transition_lifecycle_rules
      content {
        noncurrent_days = noncurrent_version_transition.value["noncurrent_days"]
        storage_class   = noncurrent_version_transition.value["storage_class"]
      }
      
    }

    status = "Enabled"
  }
}

resource "aws_s3_object" "terraform_bucket_object" {
  count = local.create_s3_bucket && local.create_s3_object ? length(var.bucket_objects) : 0
  key          = var.bucket_objects[count.index]["key"]
  bucket       = aws_s3_bucket.terraform_bucket[0].id
  source       = var.bucket_objects[count.index]["source"]
  content_type = var.bucket_objects[count.index]["content_type"]

  tags = {
    Env = var.s3_bucket_tags["environment"]
  }
}

resource "aws_s3_bucket_website_configuration" "bucket_static_website" {
  count = local.create_s3_bucket && local.create_s3_bucket_website_configuration ? 1 : 0
  bucket = aws_s3_bucket.terraform_bucket[0].id

  index_document {
    suffix = "index.html"
  }
}