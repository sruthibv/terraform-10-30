provider "aws" {
  region = "ap-south-1"
}

locals {
  region = "ap-south-1"
  instance_type = "t2.micro"
}

resource "aws_instance" "server" {
  ami           = "ami-062f0cc54dbfd8ef1" 
  instance_type = local.instance_type

  tags = {
    Name = "dev-${local.region}"
  }
}