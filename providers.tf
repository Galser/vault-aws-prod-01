terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }
}

provider "aws" {
  # Configuration options for AWS
  # don't forget to define proper env variables :
  # export AWS_ACCESS_KEY_ID=xxxx
  # export AWS_SECRET_ACCESS_KEY=YYYY
  # export AWS_SESSION_TOKEN=ZZZZ
  region = var.region
}
