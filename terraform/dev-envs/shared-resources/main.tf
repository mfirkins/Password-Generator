terraform {
  required_version = ">=1.1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.21.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      env                  = terraform.workspace
      shared_resources_env = terraform.workspace
      shared_resources     = "true"
    }
  }


}

## Creates shared resources
module "main" {
  source          = "briancaffey/ad-hoc-environments/aws"
  version         = "0.8.0"
  certificate_arn = var.certificate_arn
  key_name        = var.key_name
  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}
