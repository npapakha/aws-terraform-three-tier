resource "aws_db_subnet_group" "default" {
  name       = "${var.name}-rds-subnet-group"
  subnet_ids = var.subnets

  tags = {
    Name = "${var.name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "db_instance" {
  identifier = "${var.name}-rds"

  db_name                     = var.name
  username                    = var.username
  manage_master_user_password = true

  multi_az              = var.multi_az
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  storage_type          = var.storage_type
  storage_encrypted     = true
  allocated_storage     = var.allocated_storage
  max_allocated_storage = 2 * var.allocated_storage

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = var.security_groups

  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention_period
  maintenance_window      = var.maintenance_window

  skip_final_snapshot = true
  publicly_accessible = false
}
