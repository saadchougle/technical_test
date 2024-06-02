provider "aws" {
  region = "eu-west-1"
}

module "aws_vpc" {
  source                     = "./modules/aws_vpc"
  cidr_block                 = "173.30.0.0/22"
  public_subnet_cidr_block   = ["173.30.0.0/25", "173.30.0.128/25"]
  private_subnet_cidr_block  = ["173.30.1.0/25", "173.30.1.128/25"]
  availability_zones         = ["eu-west-1a", "eu-west-1b"]
  name                       = "wordpress"
  env                        = "techtest"
}

/*
module "wp_sg" {
  source             = "./modules/security_groups"
  vpc_id             = module.aws_vpc.vpc_id
  sg_name            = "wp-sg"
  protocol           = "tcp"
  inbound_ip_sources = [{"from":8080, "to":8080, "source":"0.0.0.0/0"}, {"from":443, "to":443, "source":"0.0.0.0/0"}]
  inbound_sg_sources = []
  name               = "wordpress"
  env                = "techtest"
}
*/
module "rds_sg" {
  source             = "./modules/aws_sg"
  vpc_id             = module.aws_vpc.vpc_id
  sg_name            = "rds-sg"
  protocol           = "tcp"
  inbound_ip_sources = []
  inbound_sg_sources = [/*{"from":3306, "to":3306, "source":module.wp_sg.sg_id}*/]
  name               = "wordpress"
  env                = "techtest"
}

module "aws_rds" {
  source              = "./modules/aws_rds"
  engine              = "mysql"
  engine_version      = "8.0.35"
  instance_class      = "db.t3.micro"
  db_name             = "bn-wordpress"
  db_username         = "admin"
  db_password         = "bntest#1234"
  allocated_storage   = 20
  db_sg_id            = [module.rds_sg.security_group_id]
  db_subnetgroup_name = "mysql_subnetgroup"
  db_subnet_ids       = module.aws_vpc.private_subnet_ids
  name                = "wordpress"
  env                 = "techtest"
}