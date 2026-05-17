resource "aws_security_group" "portfolio_sg" {
  name = "portfolio-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "portfolio_server" {

  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"

  key_name = "2026_key"

  vpc_security_group_ids = [
    aws_security_group.portfolio_sg.id
  ]

  tags = {
    Name = "terraform-portfolio-server"
  }
}
resource "aws_eip" "portfolio_eip" {

  instance = aws_instance.portfolio_server.id

  domain = "vpc"

  tags = {
    Name = "portfolio-elastic-ip"
  }
}