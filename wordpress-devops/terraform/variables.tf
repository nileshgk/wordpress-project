# AWS region
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

# Project name
variable "project_name" {
  description = "Project name"
  type        = string
  default     = "wordpress-devops"
}

# EC2 instance type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# EC2 key pair name
variable "key_name" {
  description = "AWS EC2 key pair name"
  type        = string
}

# Public SSH key path
variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}