provider "aws" {
  alias  = "primary"
  region = "ap-south-1"  # Mumbai
}

provider "aws" {
  alias  = "secondary"
  region = "eu-west-2"  # London, cross region
}