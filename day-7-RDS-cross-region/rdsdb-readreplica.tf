

#creating a subnet group

resource "aws_db_subnet_group" "sub_group_db" {
  tags = {
    Name = "DB Subnet Group"
  }
  description = "creating subnet group for db"
  name = "subnet_group"
  subnet_ids = [ aws_subnet.pvt_1.id, aws_subnet.pvt_2.id ]
}

# parameter group
resource "aws_db_parameter_group" "pg_db" {
  name_prefix = "my-pg"
  family      = "mysql8.0"
}

# IAM role for RDS monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role-2"
  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Effect = "Allow",
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  provider = aws.primary
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


# db instance
resource "aws_db_instance" "rds_test" {
  provider                  = aws.primary
  engine                    = "mysql"
  engine_version            = "8.0.41"
  multi_az                  = false
  identifier                = "database-1"
  db_name                   = "mydb"
  username                  = var.db_username
  password                  = var.db_password
  instance_class            = var.instance_class
  parameter_group_name      = aws_db_parameter_group.pg_db.name
  storage_type              = "gp2"
  allocated_storage         = 10
  db_subnet_group_name      = aws_db_subnet_group.sub_group_db.name
  publicly_accessible       = false
  vpc_security_group_ids    = [aws_security_group.sg.id]
  availability_zone         = "eu-west-2a"
  skip_final_snapshot       = true
  delete_automated_backups  = true
  backup_retention_period   = 7
  
}



resource "aws_db_instance" "cross_region_db_replica" {
  provider                = aws.secondary 
  replicate_source_db     = aws_db_instance.rds_test.arn
  instance_class          = var.instance_class
  availability_zone       = "ap-south-1a"
  identifier              = "database-1-cross-region-replica"
  publicly_accessible     = false

  apply_immediately       = true
  skip_final_snapshot     = true
  backup_retention_period = 7
  delete_automated_backups= true
  depends_on              = [ aws_db_instance.rds_test ]

}

