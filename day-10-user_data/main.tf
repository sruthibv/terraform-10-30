provider "aws" {
  
}
resource "aws_instance" "css-test-user-data" {
    ami = "ami-0f1dcc636b69a6438"
    instance_type = "t2.micro"
    user_data= file("test.sh")
    tags = {
      Name = "css"
    }
}