provider "aws" { 
}

resource "aws_instance" "test" {
    ami = "ami-0f1dcc636b69a6438"   
    instance_type = "t2.micro"
    key_name = "mumbai"
    tags = {
      Name = "dev"
    }
    user_data = file("${path.module}/test.sh")

     
}