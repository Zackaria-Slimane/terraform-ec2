terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "terraform-jenkins" {
  ami                    = "ami-0505148b3591e4c07"
  instance_type          = "t2.micro"
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.prefix
  }
  user_data = data.template_file.userdata.rendered
}

locals {
  ingress_ports = [22, 8080,9000]
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