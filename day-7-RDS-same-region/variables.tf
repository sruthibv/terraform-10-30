# VPC
variable "vpc_cidr" {
    description = "VPC CIDR"
    type = string
    default = "10.0.0.0/16"
}

# Public Subnets
variable "public_subnets" {
    description = "VPC CIDR"
    type = map(string)
    default = {
        pub_1 = "10.0.1.0/24"
        pub_2 = "10.0.2.0/24"
    }
}

# Private Subnets
variable "private_subnets" {
    description = "VPC CIDR"
    type = map(string)
    default = {
        pvt_1 = "10.0.3.0/24"
        pvt_2 = "10.0.4.0/24"
    }
}

variable "db_username" {
  description = "The username of the database"
  type        = string
  default     = "admin"
  sensitive   = true
}
variable "db_password" {
  description = "The password of the database"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}
