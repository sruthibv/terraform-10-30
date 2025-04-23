provider "aws" {
  alias  = "primary"
  region = "ap-south-1"  # Mumbai
}

provider "aws" {
  alias  = "secondary"
  region = "ap-south-1"  # Still Mumbai, same region
}