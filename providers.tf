terraform {
  required_providers {
    aws = {
      source  = "hashicorp/terraform-provider-aws"
    }
  }
}

provider "aws" {
  region  = "eu-north-1"
}
