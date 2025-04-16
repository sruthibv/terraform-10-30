variable "ami" {
    description = "inserting ami id into main"
    type = string
    default = "ami-002f6e91abff6eb96"
}

variable "instance_type" {
    
    description = "change of type of instance into main"
    type = string
    default = "t2.micro"

}
