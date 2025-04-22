# 1. Creation of VPC
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "Cust-VPC-1"
    }
}

# 2. Creation of Subnets
resource "aws_subnet" "pub_1" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-south-1a"
    tags = {
        Name = "Public-subnet-1"
    }
}

resource "aws_subnet" "pvt_1" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-south-1a"
    tags = {
        Name = "Private-subnet-1"
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
}

# 5. Creation of NAT Gateway 
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub_1.id
  tags = {
    Name = "Cust NAT GW"
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

resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-rt"
  }
}

# 8. Edit Subnet association
resource "aws_route_table_association" "pub_sub" {
  subnet_id      = aws_subnet.pub_1.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pvt_sub" {
  subnet_id      = aws_subnet.pvt_1.id
  route_table_id = aws_route_table.pvt_rt.id
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

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# 10. Creation of Public server
resource "aws_instance" "pub_server" {
    ami = "ami-0f1dcc636b69a6438"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.pub_1.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.sg.id]
    tags = {
      Name = "Public_server"
    }
}

# 11. Creation of Private server
resource "aws_instance" "pvt_server" {
    ami = "ami-0f1dcc636b69a6438"
    instance_type = "t2.micro"
    key_name = "mumbai"
    subnet_id = aws_subnet.pvt_1.id
    associate_public_ip_address = false
    vpc_security_group_ids = [aws_security_group.sg.id]
    tags = {
      Name = "Private_server"
    }
}

