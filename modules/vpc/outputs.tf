output "public_subnet_id" {
  value = aws_subnet.public_subnet_1a.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet_1b.id
}

output "public_sg" {
  value = aws_security_group.allow_ssh_public.id
}

output "private_sg" {
  value = aws_security_group.allow_ssh_icmp_private.id
}