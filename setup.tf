terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

# Configure AWS account settings
provider "aws" {
  profile = "default"
  region  = var.region
}