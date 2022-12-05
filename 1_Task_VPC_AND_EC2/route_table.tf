# resource "aws_route_table" "route_table_test_2" {
#   vpc_id = aws_vpc.runner.id
#   //depends_on = [aws_internet_gateway.main]

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     //Name = "Route Table ${local.instance_name}"
#     Name = "${local.main_name}-igw"
#   }
# }

resource "aws_default_route_table" "default_route_table_id" {
  default_route_table_id = aws_vpc.runner.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.main_name}-RouteTable"
  }
}
