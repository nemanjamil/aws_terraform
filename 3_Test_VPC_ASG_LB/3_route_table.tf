resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.runner.id
  //depends_on = [aws_internet_gateway.main]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.main_name}-Public_RouteTable"
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.runner.id
  //depends_on = [aws_internet_gateway.main]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.main_name}-Private_RouteTable"
  }
}

resource "aws_route_table_association" "add_subnet_public_1" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "add_subnet_public_2" {
  subnet_id      = aws_subnet.public-us-east-1b.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "add_subnet_public_3" {
  subnet_id      = aws_subnet.public-us-east-1c.id
  route_table_id = aws_route_table.public_rt.id
}



# #Default Route Table
# resource "aws_default_route_table" "default_route_table_id" {
#   default_route_table_id = aws_vpc.runner.default_route_table_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "${local.main_name}-RouteTable"
#   }
# }
