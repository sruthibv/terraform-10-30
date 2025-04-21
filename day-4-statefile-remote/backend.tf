


terraform {
  backend "s3" {
    bucket = "statefilebackendbucketforremote"
    key    = "terraform.tfstate"   
    region = "ap-south-1"
  }
}