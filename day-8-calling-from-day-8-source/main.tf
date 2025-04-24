module "test_calling_day_8_source" {
    source = "../day-8-source-modules"
    ami = "ami-0f1dcc636b69a6438"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"

}