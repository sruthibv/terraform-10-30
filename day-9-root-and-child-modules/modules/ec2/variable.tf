variable "ami_id" {
  description = "ami id of instance"
  type = string
  default = ""
}

variable "instance_type" {
  description = "instance type"
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