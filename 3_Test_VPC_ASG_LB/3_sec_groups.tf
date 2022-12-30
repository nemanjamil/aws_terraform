#A Security Group for the ELB so it is accessible via the web

resource "aws_security_group" "alb" {
  name        = "${local.main_name} ELB SG"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id      = aws_vpc.runner.id
  tags = {
    Name = "${local.main_name}-ELB Security Group"
  }


  #HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Default security group to acess the instances over SSH and HTTP
resource "aws_security_group" "ec2" {
  name        = "${local.main_name} EC2 SG"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id      = aws_vpc.runner.id
  tags = {
    Name = "${local.main_name}-EC2 Security Group"
  }

  #HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  #SSH access from the internet
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ssh" {
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}