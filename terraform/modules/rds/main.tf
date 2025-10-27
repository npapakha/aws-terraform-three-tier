resource "aws_db_subnet_group" "default" {
  name       = "${var.db_name}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "db_instance" {
  instance_class = var.instance_class
  identifier     = "${var.db_name}-rds"
  multi_az       = var.multi_az

  db_name                     = var.db_name
  username                    = var.username
  manage_master_user_password = true

  engine                = var.engine
  engine_version        = var.engine_version
  storage_type          = var.storage_type
  storage_encrypted     = true
  allocated_storage     = var.allocated_storage
  max_allocated_storage = 2 * var.allocated_storage

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = var.security_group_ids

  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention_period
  maintenance_window      = var.maintenance_window

  skip_final_snapshot = true
  publicly_accessible = false
}
