terraform {
  required_version = ">=1.1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.21.0"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}


resource "aws_s3_bucket" "this" {
  bucket = "${var.environment_name}-bucket"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "this" {
  name           = "${var.environment_name}-lock-table"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_ecr_repository" "backend" {
  name                 = "jool-dev-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}



