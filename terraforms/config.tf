terraform {
  backend "s3" {
    profile = "hyungkyu"
    bucket  = "ukswm"
    key     = "terraform-state-dev"
    region  = "eu-west-1"
  }
  required_version = "~>1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
