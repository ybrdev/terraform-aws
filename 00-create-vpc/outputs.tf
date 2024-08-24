output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.subnet_public_a.id, aws_subnet.subnet_public_b.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.subnet_private_a.id, aws_subnet.subnet_private_b.id]
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = [aws_nat_gateway.nat_gw_a.id, aws_nat_gateway.nat_gw_b.id]
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.rtb_public.id
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = [aws_route_table.rtb_private_a.id, aws_route_table.rtb_private_b.id]
}

output "s3_vpc_endpoint_id" {
  description = "The ID of the VPC Endpoint for S3"
  value       = aws_vpc_endpoint.vpc_endpoint_s3.id
}