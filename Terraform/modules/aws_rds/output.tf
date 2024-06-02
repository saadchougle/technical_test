output "subnet_group" {
  description = "The name of the Subnet Group"
  value = aws_db_subnet_group.rds_subnetgroup.name
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value = aws_db_instance.rds.endpoint
}