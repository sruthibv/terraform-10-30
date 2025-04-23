output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = [
    aws_subnet.pub_1.id,
    aws_subnet.pub_2.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value = [
    aws_subnet.pvt_1.id,
    aws_subnet.pvt_2.id
  ]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_1az.id
}

output "nat_gateway_eip" {
  description = "Elastic IP associated with NAT Gateway"
  value       = aws_eip.eip.public_ip
}

output "public_instance_id" {
  description = "Instance ID of the public server"
  value       = aws_instance.pub_server.id
}

output "public_instance_public_ip" {
  description = "Public IP of the public server"
  value       = aws_instance.pub_server.public_ip
}

output "private_instance_id" {
  description = "Instance ID of the private server"
  value       = aws_instance.pvt_server.id
}

output "rds_primary_endpoint" {
  description = "The connection endpoint for the primary RDS instance"
  value       = aws_db_instance.rds_test.endpoint
}

output "rds_replica_endpoint" {
  description = "The connection endpoint for the read replica"
  value       = aws_db_instance.db_replica.endpoint
}

output "rds_primary_db_name" {
  description = "Database name for the primary instance"
  value       = aws_db_instance.rds_test.db_name
}

output "rds_primary_identifier" {
  description = "RDS instance identifier for the primary DB"
  value       = aws_db_instance.rds_test.id
}

output "rds_replica_identifier" {
  description = "RDS instance identifier for the replica"
  value       = aws_db_instance.db_replica.id
}

output "rds_security_group_id" {
  description = "Security group attached to the RDS instance"
  value       = aws_security_group.sg.id
}

output "db_subnet_group_name" {
  description = "Name of the subnet group used by RDS"
  value       = aws_db_subnet_group.sub_group_db.name
}
