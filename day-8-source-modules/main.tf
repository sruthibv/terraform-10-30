
#Creation of Public server
resource "aws_instance" "pub_server-1" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    availability_zone = var.availability_zone
    associate_public_ip_address = true
    key_name = var.key_name
    tags = {
      Name = "Public_server"
    }
}



    
