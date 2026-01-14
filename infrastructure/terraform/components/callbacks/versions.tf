terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13"
    }

  }

  required_version = ">= 1.10.1"
}
