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

module "wp_sg" {
  source             = "./modules/aws_sg"
  vpc_id             = module.aws_vpc.vpc_id
  sg_name            = "wp-sg"
  protocol           = "tcp"
  inbound_ip_sources = [{"from":80, "to":80, "source":"0.0.0.0/0"}, {"from":8080, "to":8080, "source":"0.0.0.0/0"}]
  inbound_sg_sources = []
  name               = "wordpress"
  env                = "techtest"
}

module "rds_sg" {
  source             = "./modules/aws_sg"
  vpc_id             = module.aws_vpc.vpc_id
  sg_name            = "rds-sg"
  protocol           = "tcp"
  inbound_ip_sources = []
  inbound_sg_sources = [{"from":3306, "to":3306, "source":module.wp_sg.security_group_id}]
  name               = "wordpress"
  env                = "techtest"
}

module "aws_rds" {
  source              = "./modules/aws_rds"
  engine              = "mysql"
  engine_version      = "8.0.35"
  instance_class      = "db.t3.micro"
  db_name             = "wordpress"
  db_username         = "admin"
  db_password         = "bntest#1234"
  allocated_storage   = 20
  db_sg_id            = [module.rds_sg.security_group_id]
  db_subnetgroup_name = "mysql_subnetgroup"
  db_subnet_ids       = module.aws_vpc.private_subnet_ids
  name                = "wordpress"
  env                 = "techtest"
}

module "s3_bucket" {
  source = "./modules/aws_s3"
  name   = "wordpress"
  env    = "techtest"
}

module "aws_ecs" {
  source                   = "./modules/aws_ecs"
  cluster_name             = "bitnami-wp-cluster"
  task_family              = "bitnami-wp-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::992382580810:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::992382580810:role/ecsTaskExecutionRole"
  container_name           = "wordpress"
  container_image          = "992382580810.dkr.ecr.eu-west-1.amazonaws.com/wp-techtest:latest"
  container_cpu            = 1024
  container_memory         = 1024
  container_environment = [
        {
          name = "WORDPRESS_DATABASE_USER"
          value = "admin"
        },
        {
          name = "WORDPRESS_DATABASE_PASSWORD"
          value = "bntest#1234"
        },
        {
          name = "WORDPRESS_DATABASE_HOST"
          value = split(":", module.aws_rds.rds_endpoint)[0]
        },
        {
          name = "WORDPRESS_DATABASE_NAME",
          value = "wordpress"
        }
      ]
  portMappings            = [
        {
          "name": "8080",
          "containerPort": 8080,
          "hostPort": 8080,
          "protocol": "tcp"
        },
        {
          "name": "80",
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
  ]
  service_name            = "bitnami-wp-service"
  desired_count           = 1
  subnet_ids              = module.aws_vpc.public_subnet_ids
  security_group_ids      = [module.wp_sg.security_group_id]
  name                    = "wordpress"
  env                     = "techtest"
}