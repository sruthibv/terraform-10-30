provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "server" {
  ami           = "ami-062f0cc54dbfd8ef1" 
  instance_type = "t2.micro"

  tags = {
    Name = "Public-instance-1"
  }
}

resource "aws_instance" "instance" {
  ami           = "ami-062f0cc54dbfd8ef1" 
  instance_type = "t2.micro"

  tags = {
    Name = "Public-instance-2"
  }
}

