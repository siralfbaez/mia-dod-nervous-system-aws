terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # For now, we use local backend.
  # In a real Treasury High environment, this would point to an encrypted S3 bucket + DynamoDB Lock.
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "mia-dod-nervous-system-aws"
      Environment = "Dev-PoC"
      Compliance  = "Treasury-High"
      ManagedBy   = "Terraform"
      Owner       = "Alf-Baez-Architect"
      DataClass   = "Restricted"
    }
  }
}