variable "name" {
  description = "The name prefix for the associated project resource"
  type = string
}

variable "env" {
  description = "The environment for the associated project resource"
  type = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type = string
}

variable "enable_dns_hostnames" {
  description = "A flag to enable/disable DNS hostnames in the VPC"
  type = bool
  default = true
}

variable "public_subnet_cidr_block" {
  description = "A list of CIDR blocks for the public subnet"
  type = list(string)
}

variable "private_subnet_cidr_block" {
  description = "A list of CIDR blocks for the private subnet"
  type = list(string)
}

variable "availability_zones" {
  description = "A list of availability_zones in the region" 
  type = list(string)
}

