resource "aws_security_group" "vpc2-sg" {
  name        = "Test 2 SG"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id      = aws_vpc.runner.id
  tags = {
    Name = "VPC Security Group"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.runner.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.runner.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
