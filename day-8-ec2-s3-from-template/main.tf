module "ec2" {
  source        = "../day-8-source-modules"
  ami           = "ami-0f1dcc636b69a6438"
  instance_type = "t2.micro"
  key_name      = "mumbai"

}

