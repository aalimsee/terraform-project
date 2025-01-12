resource "aws_route_table" "aalimsee_tf_public" {
  vpc_id = aws_vpc.aalimsee_tf_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aalimsee_tf_igw.id
  }

  tags = {
    Name = "aalimsee-tf-public-route-table"
  }
}

resource "aws_route_table_association" "aalimsee_tf_public" {
  count          = 3
  subnet_id      = aws_subnet.aalimsee_tf_public[count.index].id
  route_table_id = aws_route_table.aalimsee_tf_public.id
}
