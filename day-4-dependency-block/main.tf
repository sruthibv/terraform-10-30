resource "aws_vpc" "VPC" {
    cidr_block = "10.0.0.0/16"
    depends_on = [ aws_instance.Public_server ]
}

resource "aws_instance" "Public_server" {
    ami = "ami-002f6e91abff6eb96"
    instance_type = "t2.micro"

    tags = {
      Name = "public-server"
    }

   
}