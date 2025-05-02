variable "names" {
  default = ["test-1","test-2","test-3"]
  type = list(string)
}


resource "aws_instance" "test" {
    ami = "ami-0f1dcc636b69a6438"
    instance_type = "t2.micro"
    key_name = "mumbai"
    availability_zone = "ap-south-1a"
    count = length(var.names)
    
    tags = {
      Name = var.names[count.index]  
    }
}

