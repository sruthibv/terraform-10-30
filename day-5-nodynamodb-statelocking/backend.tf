terraform {
  backend "s3" { 
    bucket = "nodynamodbstatefilelockingfors3" # Name of the S3 bucket where the state will be stored.
    key    = "terraform.tfstate"   
    region = "ap-south-1" # Path within the bucket where the state will be read/written.
    use_lockfile = true
    encrypt        = true  # Ensures the state is encrypted at rest in S3.
  }
}

