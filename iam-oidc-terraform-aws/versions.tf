terraform {
  ## Use for prd
  # backend "s3" {
  #   bucket    = "mybucket"
  #   key       = "tfstate"
  #   region    = "us-east-1"
  #   profile   = ""
  # }

  required_version = ">= 1.2.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
  }
}