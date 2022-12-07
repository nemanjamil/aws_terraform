#contains vpc, subnets, internet gateway, nat, routing table

locals {
  instance_name = "${terraform.workspace}-instance"
  main_name     = "Test2"
  timestamp     = formatdate("YYYYMMDDhhmmss", timestamp())
  prefix        = "route-${local.timestamp}"
}

# VPC
resource "aws_vpc" "runner" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.main_name}-VPC"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.runner.id
  tags = {
    Name = "${local.main_name}-SecGroup"
  }
}

# Subnets
resource "aws_subnet" "public-us-east-1a" {
  vpc_id            = aws_vpc.runner.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az-1a

  tags = {
    Name = "${local.main_name}-public-us-east-1a"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id            = aws_vpc.runner.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az-1b

  tags = {
    Name = "${local.main_name}-public-us-east-1b"
  }
}

resource "aws_subnet" "public-us-east-1c" {
  vpc_id            = aws_vpc.runner.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.az-1c

  tags = {
    Name = "${local.main_name}-public-us-east-1c"
  }
}


# AWS internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.runner.id
  tags = {
    Name = "${local.main_name}-igw"
  }
}
