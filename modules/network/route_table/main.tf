resource "aws_route_table" "private_1a" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-private-route-table-1a"
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = var.subnet_1a_id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table" "private_1b" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-private-route-table-1b"
  }
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = var.subnet_1b_id
  route_table_id = aws_route_table.private_1b.id
}