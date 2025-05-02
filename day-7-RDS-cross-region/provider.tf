provider "aws" {
  alias  = "primary"
  region = "eu-west-2"  # london
}

provider "aws" {
  alias  = "secondary"
  region = "ap-south-1"  # Mumbai, cross region
}