# # Understanding how local-exec works, then we can combine everything and work. 

# resource "aws_instance" "server" {
#   ami                    = "ami-0f1dcc636b69a6438"
#   instance_type          = "t2.micro"

# provisioner "local-exec" {
#   command = "echo 'Instance created' > test.txt"
# }
# }

# #after running apply command, a local file test.txt has been created in local. 
# #you can see text file in your directory. 
# # inside your file, you can see whatever you have given there
