resource "aws_instance" "name" {
    ami = var.ami
    instance_type = var.instance_type
}

/*
resource "aws_s3_bucket" "name" {
    bucket = "sruthilovesnarutouzumakiandharrypotter"
}
*/