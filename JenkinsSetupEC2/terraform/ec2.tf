# Generate SSH Key Pair
resource "tls_private_key" "jenkins" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key locally
resource "local_file" "private_key" {
  filename        = "${path.module}/../keys/jenkins.pem"
  content         = tls_private_key.jenkins.private_key_pem
  file_permission = "0400"
}

# Create AWS Key Pair
resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-key"
  public_key = tls_private_key.jenkins.public_key_openssh
}

# Jenkins EC2 Instance
resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  key_name = aws_key_pair.jenkins.key_name

  vpc_security_group_ids = [
    aws_security_group.jenkins.id
  ]

  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  user_data = file("${path.module}/../scripts/install_jenkins.sh")

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name        = "${var.project_name}-jenkins"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

#########################################
# Attach AdministratorAccess
#########################################

resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#########################################
# Instance Profile
#########################################

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}