output "vpc_id" {
  value = aws_vpc.network_vpc_module.id
}

output "public_subnets" {
  value = aws_subnet.aalimsee_tf_public[*].id
}

output "private_subnets" {
  value = aws_subnet.aalimsee_tf_private[*].id
}
