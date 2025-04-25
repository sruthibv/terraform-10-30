variable "db_name" {
  type        = string
  description = "The name of the RDS database instance"
  default     = ""
}

variable "instance_class" {
  type        = string
  description = "The instance type of the RDS database (e.g., db.t3.micro)"
  default     = ""
}

variable "db_username" {
  type        = string
  description = "The master username for the RDS database"
  default     = ""
}

variable "db_password" {
  type        = string
  description = "The master password for the RDS database"
  sensitive   = true
  default     = ""
}

