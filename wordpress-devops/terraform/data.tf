# Get the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {

  # Use the most recent image
  most_recent = true

  # Canonical (Ubuntu) AWS account ID
  owners = ["099720109477"]

  # Ubuntu 22.04 LTS AMI
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  # HVM virtualization
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}