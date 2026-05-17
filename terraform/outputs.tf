output "security_group_id" {
  value = aws_security_group.portfolio_sg.id
}
output "elastic_ip" {
  value = aws_eip.portfolio_eip.public_ip
}