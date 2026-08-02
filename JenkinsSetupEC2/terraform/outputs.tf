output "jenkins_public_ip" {
  description = "Jenkins EC2 Public IP"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_public_dns" {
  description = "Jenkins EC2 Public DNS"
  value       = aws_instance.jenkins.public_dns
}

output "jenkins_url" {
  description = "Jenkins Web URL"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "ssh_command" {
  description = "SSH Command"
  value       = "ssh -i keys/jenkins.pem ubuntu@${aws_instance.jenkins.public_ip}"
}