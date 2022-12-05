resource "aws_security_group" "ec2-sg" {
  name        = "${local.main_name} EC2 SG"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id      = aws_vpc.runner.id
  tags = {
    Name = "${local.main_name}-EC2 Security Group"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    //cidr_blocks = [aws_vpc.runner.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
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
