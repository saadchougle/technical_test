# Creating AWS RDS
resource "aws_db_instance" "rds" {
  identifier             = lower("${var.db_name}-db")
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = var.db_sg_id
  db_subnet_group_name   = var.db_subnetgroup_name
  multi_az               = var.multi_az 
  skip_final_snapshot    = true
  tags = {
    Name = "${var.name}-${var.env}-${var.db_name}-db"
  }
}
