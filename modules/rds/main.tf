resource "aws_db_subnet_group" "db_sg" {
  name = "${var.env}-db-sg"
  subnet_ids = [
    var.subnet_db_1a_id,
    var.subnet_db_1b_id
  ]

  tags = {
    Name = "${var.env} subnet group"
  }
}