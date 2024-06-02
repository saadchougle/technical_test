variable "name" {
  description = "The name prefix for the associated project resource"
  type        = string
}

variable "env" {
  description = "The environment prefix for the associated project resource"
  type        = string
}

variable "description" {
  description = "The description of the Security Group"
  type        = string
  default     = "Managed by Terraform"
}

variable "sg_name" {
  description = "The name of the Security Group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
variable "inbound_ip_sources" {
}

variable "inbound_sg_sources" {
}

variable "protocol" {
    type = string
}