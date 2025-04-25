# ami for ec2
variable "ami" {
    description = "ami for ec2"
    type = string
    default = ""
}

# instance type
variable "instance_type" {
    description = "instance type for ec2"
    type = string
    default = ""
}
   
# key pair for server
variable "key_name" {
    description = ".pem key pair"
    type = string
    default = ""
}  

# availability zone
variable "availability_zone" {
    description = "availability for the public server"
    type = string
    default = ""
}  

variable "tags" {
  description = "name of the instance"
  type = map(string)
  default = {
    Name = "" 
  } 
}

# s3 bucket
variable "aws_s3_bucket" {
    description = "s3 bucket unique name"
    type = string
    default = ""
 
}

