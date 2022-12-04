#contains vpc, subnets, internet gateway, nat, routing table

# VPC
resource "aws_vpc" "runner" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC_Test_2"
  }
}
# Subnets
resource "aws_subnet" "public-us-east-1a" {
  vpc_id            = aws_vpc.runner.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az-1a

  tags = {
    Name = "public-us-east-1a"
  }
}


resource "aws_subnet" "public-us-east-1b" {
  vpc_id            = aws_vpc.runner.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az-1b

  tags = {
    Name = "public-us-east-1b"
  }
}

resource "aws_subnet" "public-us-east-1c" {
  vpc_id            = aws_vpc.runner.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.az-1c

  tags = {
    Name = "public-us-east-1c"
  }
}


# AWS internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.runner.id
  tags = {
    Name = var.main_name
  }
}
