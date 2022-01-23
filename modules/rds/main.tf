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
  db_subnet_group_name    = aws_db_subnet_group.db_sg.name
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.10.2"
  availability_zones      = var.db_availability_zones
  database_name           = var.database_name
  master_username         = var.db_master_username
  master_password         = var.db_master_password
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
}

resource "aws_rds_cluster_instance" "instance1" {
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.db_cluster.id
  identifier         = "${var.env}-db1"
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.db_cluster.engine
  engine_version     = aws_rds_cluster.db_cluster.engine_version
}