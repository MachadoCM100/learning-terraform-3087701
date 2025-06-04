terraform {
  required_providers {
    aws = {
      source  = "hashicorp/terraform-provider-aws"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
}
