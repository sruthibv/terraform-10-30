# module "ec2" {
#     source = "./modules/ec2"
#     ami_id = var.ami_id
#     instance_type = var.instance_type
#     tags = var.tags
# }

# module "s3" {
#     source = "./modules/s3"
#     bucket_name = var.bucket_name
# }

module "RDS" {
  source = "./modules/rds"
  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
  instance_class = var.instance_class
}
