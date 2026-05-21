output "security_group_id" {
  value = aws_security_group.portfolio_sg.id
}

output "elastic_ip" {
  value = aws_instance.portfolio_server.public_ip
}