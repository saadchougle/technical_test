locals {
  az_count = length(var.availability_zones)
}

# Creating a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = "${var.name}-${var.env}-vpc"
  }
}

# Creating Public Subnets
resource "aws_subnet" "public" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-${var.env}-public-subnet-${count.index+1}"
  }
}

# Creating Private Subnets
resource "aws_subnet" "private" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnet_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-${var.env}-private-subnet-${count.index+1}"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-${var.env}-IGW"
  }
}

# Creating a Route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.name}-${var.env}-public-RT"
  }
}

# Creating route Table association with public subnets
resource "aws_route_table_association" "public-association" {
  count          = local.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

/* Uncomment if you wish to create Nat Gateway
# To create EIP for Nat-Gateway
resource "aws_eip" "natgw-eip" {
  count = 1
  domain  = "vpc"
  tags = {
    Name = "${var.name}-${var.env}-NatGW-EIP"
  }
}

# Creating Nat Gateway
resource "aws_nat_gateway" "natgw" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.natgw-eip[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.name}-${var.env}-NatGW"
}
}
*/

# Creating a Route Table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_internet_gateway.igw.id
    # Uncomment if you wish to attach Nat Gateway
    # nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "${var.name}-${var.env}-private-RT"
  }
}

resource "aws_route_table_association" "private-association" {
  count          = local.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private-rt.id
}

# Creating route Table association with private subnets using Nat Gateway
# resource "aws_route_table_association" "private-association" {
#   count          = length(var.private_subnet_cidr_block)-(local.az_count)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private-rt[count.index % local.az_count].id
# }