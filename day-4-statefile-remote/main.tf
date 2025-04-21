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
