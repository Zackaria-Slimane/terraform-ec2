terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "ec2-zs" {
  ami                    = "ami-0014ce3e52359afbd"
  instance_type          = "t3.micro"
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.prefix
  }
  user_data = data.template_file.userdata.rendered

  provisioner "file" {
    source      = "~/setup.sh"
    destination = "/tmp/setup.sh"
  }

  # ebs_block_device {
  #   device_name = "/dev/xvdb"
  #   volume_type = "gp2"
  #   volume_size = 8
  # }
	  volume_tags = {
    Name = var.prefix
  }
  connection {
    type        = "ssh"
    user        = "ec2-zs"
    password    = ""
    private_key = file(var.ssh_private_key_path)
    host        = self.public_ip
  }
	  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh",
    ]
  }

}

locals {
  ingress_ports = [22,8080,9000,3000,5137,443]
}

resource "aws_security_group" "sg" {
  name = "${var.prefix}-sg"

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