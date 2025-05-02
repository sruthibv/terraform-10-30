# resource "aws_instance" "name" {
#   for_each = {
#     server1 = "10.0.0.10"
#     server2 = "10.0.0.20"
#   }
#     ami = "ami-0f1dcc636b69a6438"
#     instance_type = "t2.micro"   
#     tags = {
#       Name = each.key
#     }

# }


#second example

variable "names" {
  default = ["test-1","test-3"]
  type = list(string)
}


resource "aws_instance" "test" {
    ami = "ami-0f1dcc636b69a6438"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
    for_each = toset(var.names)
    
    tags = {
      Name = each.value 
    }
}

# dini batti em ardam ayindayya ante... count use chesinapudu test-2 delete cheste, 
# test-3 anedi, test-2 instance place lo ki vastundi. actually test-3 delete ayinatu ardam. 
# idi enduku jarigindi ante, count sequence order lo tisukuntundi, so last di delete chesindi. 

#for each use chesinapudu test-2 dlete cheste, test-2 eh delete ayindi. verevi delete avala. 