# AWS Region
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

# Project Name
variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "jenkins-setup"
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.small"
}

# Root Volume Size
variable "volume_size" {
  description = "Root EBS Volume Size (GB)"
  type        = number
  default     = 30
}

# VPC CIDR
variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnet CIDR
variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

# Availability Zone
variable "availability_zone" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1a"
}