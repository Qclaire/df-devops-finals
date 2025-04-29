resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket"

  # Only create this bucket in LocalStack environment
  count = var.use_localstack ? 1 : 0

  tags = {
    Name        = "terraform-state-bucket"
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  # Only create this table in LocalStack environment
  count = var.use_localstack ? 1 : 0

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-lock"
    Environment = var.environment
  }
}