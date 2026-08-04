# Generate SSH key pair

resource "tls_private_key" "wordpress" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key locally

resource "local_file" "private_key" {
  filename        = "${path.module}/keys/wordpress.pem"
  content         = tls_private_key.wordpress.private_key_pem
  file_permission = "0400"
}

# Save public key locally
resource "local_file" "public_key" {
  filename        = "${path.module}/keys/wordpress.pub"
  content         = tls_private_key.wordpress.public_key_openssh
  file_permission = "0644"
}

# Upload public key to AWS

resource "aws_key_pair" "wordpress" {
  key_name   = "wordpress-key"
  public_key = tls_private_key.wordpress.public_key_openssh
}