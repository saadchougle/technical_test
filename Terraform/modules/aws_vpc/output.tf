output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnet"
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnet"
  value = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value = aws_internet_gateway.igw.id
}

/* Uncomment if you a have Nat Gateway
output "nat_gateway_id" {
  description = "The ID of the Internet Gateway"
  value = aws_nat_gateway.natgw.id
}
*/
