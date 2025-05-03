provider "aws" {
  region = "ap-south-1"
}

# variable "env" {
#   default = "dev"
# }
# resource "aws_instance" "server" {
#   ami           = "ami-062f0cc54dbfd8ef1" 
#   instance_type = var.env == "prod" ? "t3.micro" :  "t2.micro"

#   tags = {
#      Name = "web-${var.env}"
#   }
# }


# variable "create_bucket" {
#   description = "Set to false to not to create a S3 bucket."
#   type        = bool
#   default     = false
# }

# resource "aws_s3_bucket" "S3" {
#   count = var.create_bucket ? 1 : 0
#   bucket= "hellojack"
  

#   tags = {
#     Name        = "Conditional"
#     Environment = "dev"
#   }
# }

