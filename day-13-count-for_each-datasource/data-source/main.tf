provider "aws" {} 

data "aws_subnet" "name" {
    filter {
      name = "tag:Name"
      values = ["subnet-1b"]
    }
}


resource "aws_instance" "name" {
    ami = "ami-0f1dcc636b69a6438"
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.name.id
}


