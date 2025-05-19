terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region                  = "us-east-1"
  skip_credentials_validation = true
}

resource "aws_s3_bucket" "example" {
  bucket = "my-terraform-bucket-${random_id.bucket_id.hex}"
}

resource "random_id" "bucket_id" {
  byte_length = 6
}
