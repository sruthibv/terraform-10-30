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

# subnet id
variable "availability_zone" {
    description = "availability for the public server"
    type = string
    default = ""
}  

    
    
