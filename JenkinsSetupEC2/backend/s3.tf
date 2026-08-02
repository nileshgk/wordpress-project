# Create S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  tags = {
    Name = "Terraform Backend"
  }

}

# Enable Versioning so you can roll back if state gets corrupted
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }

}

# Encrypt state file data at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

  }

}

# Block public access entirely
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
