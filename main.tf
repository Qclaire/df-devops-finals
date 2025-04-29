terraform {
  required_providers {
    aws = {
      source  = "hashiCorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "test" # Dummy credentials for LocalStack
  secret_key = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://10.61.235.70:4566"
    # Add other service endpoints if needed, e.g.:
    # iam = "http://localhost:4566"
    # ec2 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-test-bucket"
}