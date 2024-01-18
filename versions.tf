terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.1"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access-key
  secret_key = var.my-secret-key
}