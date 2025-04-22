resource "aws_instance" "name" {
  ami = "ami-002f6e91abff6eb96"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "pub"
  }

#   lifecycle {
# 	prevent_destroy = true
# }

#   lifecycle {
#     ignore_changes = [tags,] #This means that Terraform will never update the object but will be able to create or destroy it.
#   }

# lifecycle {
#      create_before_destroy = true    #this attribute will create the new object first and then destroy the old one
#    }


}