resource "aws_subnet" "private_container_1a" {
  cidr_block              = var.container_subnet_cidr_block_1a
  vpc_id                  = var.vpc_id
  availability_zone       = var.subnet_az_1a
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-private-container-1a"
  }
}

resource "aws_subnet" "private_container_1b" {
  cidr_block              = var.container_subnet_cidr_block_1b
  vpc_id                  = var.vpc_id
  availability_zone       = var.subnet_az_1b
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-private-container-1b"
  }
}

resource "aws_subnet" "private_rds_1a" {
  cidr_block              = var.rds_subnet_cidr_block_1a
  vpc_id                  = var.vpc_id
  availability_zone       = var.subnet_az_1a
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-private-rds-1a"
  }
}

resource "aws_subnet" "private_rds_1b" {
  cidr_block              = var.rds_subnet_cidr_block_1b
  vpc_id                  = var.vpc_id
  availability_zone       = var.subnet_az_1b
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-private-rds-1b"
  }
}