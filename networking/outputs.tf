# Created for testing 
output "vpc_id" {
  value = aws_vpc.aalimsee_tf_main.id
}

output "public_subnets" {
  value = aws_subnet.aalimsee_tf_public[*].id
}

output "private_subnets" {
  value = aws_subnet.aalimsee_tf_private[*].id
}
