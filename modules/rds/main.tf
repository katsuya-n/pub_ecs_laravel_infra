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

resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier      = "${var.env}-db-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = [db_availability_zones]
  database_name           = var.database_name
  master_username         = var.db_master_username
  master_password         = var.db_master_password
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
}