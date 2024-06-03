# Creating AWS RDS
#Creating DB Subnet Group
resource "aws_db_subnet_group" "rds_subnetgroup" {
  name        = var.db_subnetgroup_name
  subnet_ids  = var.db_subnet_ids
}

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
  db_subnet_group_name   = aws_db_subnet_group.rds_subnetgroup.name
  multi_az               = var.multi_az 
  skip_final_snapshot    = true
  tags = {
    Name = "${var.name}-${var.env}-${var.db_name}-db"
  }
}
