terraform {
  backend "s3" { 
    bucket = "statefilebackendbucketforremote" # Name of the S3 bucket where the state will be stored.
    key    = "terraform.tfstate"   
    region = "ap-south-1" # Path within the bucket where the state will be read/written.
    dynamodb_table = "terraform-state-lock-dynamo" # DynamoDB table used for state locking, note: first run Day4-s3bucket-DynamoDB-create-for-backend-statefile-remote-locking
    encrypt        = true  # Ensures the state is encrypted at rest in S3.
  }
}

