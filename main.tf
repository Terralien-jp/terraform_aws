terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.1.0"
    }
  }
}

locals {
  app_name    = "my-cool-app"
  environment = "dev"
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      environment = local.environment
      application = local.app_name
    }
  }
}
