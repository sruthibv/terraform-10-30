# 1. Creation of VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Custom-VPC-1"
  }
}
# 2.1 Creation of Public Subnets
resource "aws_subnet" "pub_1" {
  cidr_block        = var.public_subnets.pub_1
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Public-subnet-1"
  }
}
resource "aws_subnet" "pub_2" {
  cidr_block        = var.public_subnets.pub_2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Public-subnet-2"
  }
}
# 2.2 Creation of Private Subnets
resource "aws_subnet" "pvt_1" {
  cidr_block        = var.private_subnets.pvt_1
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Private-subnet-1"
  }
}

resource "aws_subnet" "pvt_2" {
  cidr_block        = var.private_subnets.pvt_2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Private-subnet-2"
  }
}

# 3. Creation of IG
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Cust-IGW"
  }
}

# # 4. Creation of ELastic IP
# resource "aws_eip" "eip" {
#   domain = "vpc"
#   tags = {
#     Name = "NAT-EIP"
#   }
# }

# # 5. Creation of NAT Gateway 
# resource "aws_nat_gateway" "nat_1az" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.pub_1.id
#   tags = {
#     Name = "Cust NAT GW-1"
#   }
#   depends_on = [aws_internet_gateway.igw]

# }


# 6. Creation of RT & Edit Routes
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "pvt_rt_1" {
  vpc_id = aws_vpc.vpc.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat_1az.id
  # }
  tags = {
    Name = "private-rt-1"
  }
}

# 8.1 Public Subnet association
resource "aws_route_table_association" "pub_sub_1" {
  subnet_id      = aws_subnet.pub_1.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pub_sub_2" {
  subnet_id      = aws_subnet.pub_2.id
  route_table_id = aws_route_table.pub_rt.id
}

# 8.2 Private Subnet association
resource "aws_route_table_association" "pvt_sub_1" {
  subnet_id      = aws_subnet.pvt_1.id
  route_table_id = aws_route_table.pvt_rt_1.id
}

resource "aws_route_table_association" "pvt_sub_2" {
  subnet_id      = aws_subnet.pvt_2.id
  route_table_id = aws_route_table.pvt_rt_1.id
}

# 9. Creation of SG
resource "aws_security_group" "sg" {
  name        = "cust-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "SG"
  }

ingress = [
    for port in [22, 80, 443, 3306,8080, 9000, 3000, 8082, 8081] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_secrets_access" {
  name = "EC2SecretsAccess"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "secretsmanager_access" {
  role       = aws_iam_role.ec2_secrets_access.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-secrets-profile"
  role = aws_iam_role.ec2_secrets_access.name
}
# 10. Creation of Public server
resource "aws_instance" "public_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.pub_1.id
  key_name                    = aws_key_pair.my_key.key_name
  availability_zone           = "ap-south-1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y mariadb
              EOF
  tags = {
    Name = "Public_server"
  }
}
# 11. Creation of Private server
resource "aws_instance" "private_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.my_key.key_name
  subnet_id                   = aws_subnet.pvt_1.id
  availability_zone           = "ap-south-1a"
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "Private_server"
  }
  depends_on = [ aws_iam_instance_profile.ec2_profile ]
}

#####################################################################################################

resource "aws_secretsmanager_secret" "rds_secret" {
  name = "my-db-secret-2"
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "admin123"
  })
}

# Create a security group for the VPC endpoint
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  description = "Security Group for Secrets Manager VPC Endpoint"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC Endpoint SG"
  }
}


data "aws_vpc_endpoint_service" "secretsmanager" {
  service = "secretsmanager"
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = data.aws_vpc_endpoint_service.secretsmanager.service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.pvt_1.id ]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "secretsmanager-endpoint"
  }
}


#creating a subnet group
resource "aws_db_subnet_group" "sub_group_db" {
  tags = {
    Name = "DB Subnet Group"
  }
  description = "creating subnet group for db"
  name        = "subnet group"
  subnet_ids  = [aws_subnet.pvt_1.id, aws_subnet.pvt_2.id]

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
  
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

locals {
  db_credentials = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)
}


# db instance
resource "aws_db_instance" "rds_test" {
  engine                   = "mysql"
  engine_version           = "8.0.41"
  multi_az                 = false
  identifier               = "database-1"
  db_name                  = "mydb"
  username                = local.db_credentials.username
  password                = local.db_credentials.password
  instance_class           = var.instance_class
  parameter_group_name     = aws_db_parameter_group.pg_db.name
  storage_type             = "gp2"
  allocated_storage        = 10
  db_subnet_group_name     = aws_db_subnet_group.sub_group_db.name
  publicly_accessible      = false
  vpc_security_group_ids   = [aws_security_group.sg.id]
  availability_zone        = "ap-south-1a"
  skip_final_snapshot      = true
  delete_automated_backups = true
  backup_retention_period  = 7
    lifecycle {
    ignore_changes = [
      password
    ]
  }
}

resource "aws_key_pair" "my_key" {
  public_key = file("C:/Users/bsrut/.ssh/id_rsa_new.pub") 
  key_name   = "task"
}



resource "null_resource" "remote_sql_exec" {
  depends_on = [aws_db_instance.rds_test, aws_instance.public_server]

connection {
  type                = "ssh"
  user                = "ec2-user"
  host                = aws_instance.public_server.public_ip
  private_key         = file("C:/Users/bsrut/.ssh/id_rsa_new")
}
  
  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y awscli jq mariadb105-server",
      "mysql -h ${aws_db_instance.rds_test.address} -u ${jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["username"]} -p${jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["password"]} < /tmp/init.sql"
    ]
  }

  triggers = {
    always_run = timestamp()
  }
}
