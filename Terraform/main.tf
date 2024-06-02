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

