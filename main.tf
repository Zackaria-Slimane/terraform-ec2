terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "ec2-t3micro-zsfolio" {
  ami                    = "ami-0014ce3e52359afbd"
  instance_type          = "t3.small"
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.securityGroup-zsfolio.id]

  tags = {
    Name  = var.prefix,
    Value = "zs-portfolio"
  }

  user_data = data.template_file.userdata.rendered

  provisioner "file" {
    source      = "./setup.sh"
    destination = "/home/ubuntu/setup.sh"
  }

  volume_tags = {
    Name  = var.prefix,
    Value = "zs-portfolio"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x setup.sh",
    ]
  }

}

locals {
  ingress_ports = [22, 443, 3000]
}

resource "aws_security_group" "securityGroup-zsfolio" {
  name = "${var.prefix}-SG"

  dynamic "ingress" {
    for_each = local.ingress_ports
    iterator = port
    content {
      from_port   = port.value
      protocol    = "tcp"
      to_port     = port.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



data "template_file" "userdata" {
  template = file("${abspath(path.module)}/setup.sh")
}
