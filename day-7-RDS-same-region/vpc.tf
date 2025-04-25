# 1. Creation of VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "Custom-VPC-1"
    }
}

# 2.1 Creation of Public Subnets
resource "aws_subnet" "pub_1" {
    cidr_block = var.public_subnets.pub_1
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-south-1a"
    tags = {
        Name = "Public-subnet-1"
    }
}

resource "aws_subnet" "pub_2" {
    cidr_block = var.public_subnets.pub_2
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-south-1b"
    tags = {
        Name = "Public-subnet-2"
    }
}

# 2.2 Creation of Private Subnets
resource "aws_subnet" "pvt_1" {
    cidr_block = var.private_subnets.pvt_1
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-south-1a"
    tags = {
        Name = "Private-subnet-1"
    }
}

resource "aws_subnet" "pvt_2" {
    cidr_block = var.private_subnets.pvt_2
    vpc_id = aws_vpc.vpc.id
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

# 4. Creation of ELastic IP
resource "aws_eip" "eip" {
    domain = "vpc"
    tags = {
      Name = "NAT-EIP"
    }
}

# 5. Creation of NAT Gateway 
resource "aws_nat_gateway" "nat_1az" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub_1.id
  tags = {
    Name = "Cust NAT GW-1"
  }
  depends_on = [aws_internet_gateway.igw]
  
}


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

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1az.id
  }
  tags = {
    Name = "private-rt-1"
  }
}

# resource "aws_route_table" "pvt_rt_2" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_1az.id
#   }
#   tags = {
#     Name = "private-rt-2"
#   }
# }

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

  ingress {
    description = "SSH"
    from_port = 22
    to_port   = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port   = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "MYSQL"
    from_port = 3306
    to_port   = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# 10. Creation of Public server
resource "aws_instance" "pub_server" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.pub_1.id
    availability_zone = "ap-south-1a"
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.sg.id]
    tags = {
      Name = "Public_server"
    }
}

# 11. Creation of Private server
resource "aws_instance" "pvt_server" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = "mumbai"
    subnet_id = aws_subnet.pvt_1.id
    availability_zone = "ap-south-1a"
    associate_public_ip_address = false
    vpc_security_group_ids = [aws_security_group.sg.id]
    tags = {
      Name = "Private_server"
    }
}

