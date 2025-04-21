resource "aws_instance" "Public_server" {
    ami = "ami-002f6e91abff6eb96"
    instance_type = "t2.micro"

    tags = {
      Name = "public-server"
    }
  
}

resource "aws_instance" "Public_server-2" {
    ami = "ami-002f6e91abff6eb96"
    instance_type = "t2.micro"

    tags = {
      Name = "public-server-2"
    }
  
}