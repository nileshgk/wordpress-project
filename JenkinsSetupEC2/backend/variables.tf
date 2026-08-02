# AWS region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# S3 bucket name
variable "bucket_name" {
  description = "Terraform state bucket name"
  type        = string
}