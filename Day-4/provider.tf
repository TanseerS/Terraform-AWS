terraform {
  backend "s3" {
    bucket = "deployebucketdemo"
    key    = "dev"
    region = "ap-south-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}