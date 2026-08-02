# Upload SSH public key to AWS
resource "aws_key_pair" "wordpress" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Create EC2 instance
resource "aws_instance" "wordpress" {

  # Latest Ubuntu AMI
  ami = data.aws_ami.ubuntu.id

  # Free Tier instance
  instance_type = var.instance_type

  # Launch in public subnet
  subnet_id = aws_subnet.public.id

  # SSH key pair
  key_name = aws_key_pair.wordpress.key_name

  # Assign public IP
  associate_public_ip_address = true

  # Attach security group
  vpc_security_group_ids = [
    aws_security_group.wordpress.id
  ]

  # Root EBS volume
  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  # Enable IMDSv2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Resource tags
  tags = {
    Name        = "${var.project_name}-ec2"
    Environment = "Dev"
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}