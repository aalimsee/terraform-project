terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  module "networking_vpc_module" {
    source = "./networking/vpc"
  }
}
