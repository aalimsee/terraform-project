resource "aws_vpc" "aalimsee_tf_main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "aalimsee-tf-vpc"
  }
}
