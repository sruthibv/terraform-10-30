resource "aws_vpc" "VPC" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet-1" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.VPC.id
}

resource "aws_subnet" "subnet-2" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.VPC.id
}

resource "aws_subnet" "subnet-3" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.VPC.id
}

resource "aws_subnet" "subnet-4" {
    cidr_block = "10.0.3.0/24"
    vpc_id = aws_vpc.VPC.id
}

resource "aws_instance" "Public_server" {
    ami = "ami-002f6e91abff6eb96"
    instance_type = "t2.micro"

    tags = {
      Name = "public-server"
    }
  
}
