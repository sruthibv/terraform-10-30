resource "aws_db_instance" "this" {
  identifier          = var.db_name
  engine              = "mysql"
  instance_class      = var.instance_class
  username            = var.db_username
  password            = var.db_password
  allocated_storage   = 10
  skip_final_snapshot = true
 }