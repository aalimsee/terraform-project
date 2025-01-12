resource "aws_internet_gateway" "aalimsee_tf_igw" {
  vpc_id = aws_vpc.aalimsee_tf_main.id

  tags = {
    Name = "aalimsee-tf-igw"
  }
}
