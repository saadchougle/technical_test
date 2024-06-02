variable "name" {
  description = "The name prefix for the associated project resource"
  type        = string
}

variable "env" {
  description = "The environment prefix for the associated project resource"
  type        = string
}

variable "allocated_storage" {
  description = "The amount of allocated storage in gigabytes"
  type        =  number
}

variable "storage_type"{
  description = "The storage type to be associated with the RDS instance"
  type        = string
  default     = "gp3"
}

variable "engine" {
  description = "The database engine to use"
  type        =  string   
}

variable "engine_version" {
  description = "The version of the database engine"
  type        =  string
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        =  string
}

variable "db_name" {
  description = "The name of the database"
  type        =  string
}

variable "db_username" {
  description = "The username for the master DB user"
  type        =  string
}

variable "db_password" {
  description = "The password for the master DB user"
  type        =  string
}

variable "db_sg_id" {
  description = "A list of the SG to be associated with the RDS instance"
  type        =  list(string)
}

variable "db_subnetgroup_name" {
  description = "The name of the DB Subnet Group"
  type        =  string
}

variable "db_subnet_ids" {
  description = "A list of subnet IDs for the DB Subnet Group"
  type        =  list(string)
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        =  bool
  default     = false
}