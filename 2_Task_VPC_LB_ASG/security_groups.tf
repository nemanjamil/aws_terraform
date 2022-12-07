# resource "aws_security_group" "load-balancer" {
#   name        = "${local.main_name}-sg-alb"
#   description = "Protects the load balancer"
#   vpc_id      = aws_vpc.runner.id

#   ingress {
#     description = "HTTP traffic"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   //tags = merge(local.common_tags, {Name = "${var.project}-${var.env}-load-balancer"})
#   tags = {
#     Name = "${local.main_name}-sg-alb"
#   }
# }

resource "aws_security_group" "ec2-sg" {
  name        = "${local.main_name} EC2 SG"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id      = aws_vpc.runner.id
  tags = {
    Name = "${local.main_name}-EC2 Security Group"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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
