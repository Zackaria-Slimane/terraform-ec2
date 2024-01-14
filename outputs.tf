output "Jenkins_Server_URL" {
  value = "http://${aws_instance.ec2-t3micro-zsfolio.public_ip}:8080"
}

output "SSH_Command" {
  value = "ssh -i ${var.ssh_private_key_path} ec2-user@${aws_instance.ec2-t3micro-zsfolio.public_ip}"
}

output "Jenkins_Password_Retrieval" {
  value = "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
}
