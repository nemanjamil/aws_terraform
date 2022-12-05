# variable "awsprops" {
#     type = "map"
#     default = {
#     region = "us-east-1"
#     vpc = "vpc-5234832d"
#     ami = "ami-0c1bea58988a989155"
#     itype = "t2.micro"
#     subnet = "subnet-81896c8e"
#     publicip = true
#     keyname = "myseckey"
#     secgroupname = "IAC-Sec-Group"
#   }
# }

data "aws_ami" "latest-ec2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "web_instance" {
  ami           = data.aws_ami.latest-ec2.id
  instance_type = "t3a.nano"
  key_name      = "EC2 Tutorial"

  subnet_id                   = aws_subnet.public-us-east-1a.id
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  associate_public_ip_address = true

  #   user_data = <<-EOF
  #   #!/bin/bash -ex

  #   amazon-linux-extras install nginx1 -y
  #   echo "<h1>$(curl https://api.kanye.rest/?format=text)</h1>" >  /usr/share/nginx/html/index.html 
  #   systemctl enable nginx
  #   systemctl start nginx
  #   EOF
  user_data = <<-EOF
  #!/bin/bash
  # Use this for your user data (script from top to bottom)
  # install httpd (Linux 2 version)
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  EOF

  tags = {
    "Name" : "${local.main_name}-EC2 Server"
  }
}
