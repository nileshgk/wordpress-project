# Store Terraform state in S3
terraform {
  backend "s3" {
    bucket       = "nilesh-wordpress-devops-tfstate-2026"
    key          = "jenkins/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}