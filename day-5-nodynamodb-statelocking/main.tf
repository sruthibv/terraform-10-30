resource "aws_instance" "pub" {
  ami = "ami-0f1dcc636b69a6438"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "test"
  }
}

# resource "aws_s3_bucket" "s3" {
#   bucket = "nodynamodbstatefilelockingfors3"
# }