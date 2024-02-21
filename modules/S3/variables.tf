variable "create_s3_bucket" {
  type = bool
  default = true
}

variable "create_s3_bucket_public_access_block" {
  type = bool
  default = true
}

variable "create_s3_bucket_policy" {
  type = bool
  default = true
}

variable "create_s3_bucket_versioning" {
  type = bool
  default = true
}

variable "create_s3_bucket_lifecycle_configuration" {
  type = bool
  default = true
}

variable "create_s3_object" {
  type = bool
  default = true
}

variable "create_s3_bucket_website_configuration" {
  type = bool
  default = true
}

variable "s3_bucket_tags" {
  type = map(string)
  default = {
    name        = "s3-terraform-bucket-demo"
    environment = "dev"
  }
}


variable "bucket_policy" {
  type = object({
    effect                = string
    actions               = list(string)
    principal_type        = string
    principal_identifiers = list(string)

  })
  default = {
    effect                = "Allow"
    actions               = ["s3:GetObject"]
    principal_type        = "AWS"
    principal_identifiers = ["*"]
  }
}

variable "bucket_versioning" {
  type    = string
  default = "Enabled"
}

variable "bucket_objects" {
  type = list(map(string))
  default = [
    {
      key          = "coffee.jpg"
      source       = "S3/coffee.jpg"
      content_type = "image/jpg"
    },
    {
      key          = "beach.jpg"
      source       = "S3/beach.jpg"
      content_type = "image/jpg"
    },
    {
      key          = "index.html"
      source       = "S3/index.html"
      content_type = "text/html"
    }
  ]
}

variable "noncurrent_transition_lifecycle_rules" {
  type = map(object({
    noncurrent_days = number
    storage_class = string
  }))
  default = {
      transition_to_IA = {
        noncurrent_days = 30
        storage_class = "STANDARD_IA"
      },
      transition_to_GLACIER = {
        noncurrent_days = 60
        storage_class = "GLACIER"
      }
  }
}

variable "noncurrent_days_expiration" {
  type = number
  default = 90
}

variable "s3_bucket_force_destroy" {
  type = bool
  default = true
}