#contains vpc, subnets, internet gateway, nat, routing table

# VPC
resource "aws_vpc" "runner" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "runner-vpc"
  }
}
# Subnets
resource "aws_subnet" "private-eu-west-2a" {
  vpc_id = aws_vpc.runner.id
  cidr_block = "10.0.15.0/24"
  availability_zone = var.az-1a

  tags = {
    Name  = "private-eu-west-2a"
  }
}

resource "aws_subnet" "private-eu-west-2b" {
  vpc_id = aws_vpc.runner.id
  cidr_block = "10.0.16.0/24"
  availability_zone = var.az-1b
}

resource "aws_subnet" "public-eu-west-2a" {
  vpc_id            = aws_vpc.runner.id
  cidr_block        = "10.0.17.0/24"
  availability_zone = var.az-1a

  tags = {
    Name  = "public-eu-west-2a"
  }
}

resource "aws_subnet" "public-eu-west-2b" {
  vpc_id            = aws_vpc.runner.id
  cidr_block        = "10.0.18.0/24"
  availability_zone = var.az-1b

  tags = {
    "Name"                       = "public-eu-west-2b"
  }
}

# AWS internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.runner.id
  tags = {
    Name = "igw"
  }
}

#NAT gateway
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public-eu-west-2a.id

  tags = {
    Name = "nat"
  }
  depends_on = [aws_internet_gateway.igw]
}
