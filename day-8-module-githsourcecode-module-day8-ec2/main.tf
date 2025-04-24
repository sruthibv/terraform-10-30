module "day_8_ec2" {
  source = "github.com/sruthibv/terraform-10-30/day-8-source-modules"
  ami = "ami-0f1dcc636b69a6438"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"


}

# I tried copy pasting the source of day-8 to see if calling particular entities. it worked
