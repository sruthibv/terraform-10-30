
#Creation of Public server
resource "aws_instance" "pub_server_1" {
    ami = var.ami
    instance_type = var.instance_type
    availability_zone = var.availability_zone
    key_name = var.key_name
    tags = var.tags
}


#creation of s3
resource "aws_s3_bucket" "s3" {
  bucket = var.aws_s3_bucket
}   
