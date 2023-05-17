terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "basic-http-sg" {
  name        = "basic-http"
  description = "Basic HTTP Server SG"

  // To Allow SSH Transport
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "cloudinit_config" "server_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/server.yml", {
      vpn_network_ip : var.vpn_network_ip,
      vpn_subnet_mask : var.vpn_subnet_mask
    })
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  key_name      = "firstmaster"
  user_data     = data.cloudinit_config.server_config.rendered

  vpc_security_group_ids = [
    aws_security_group.basic-http-sg.id
  ]

  tags = {
    Name = "BVKTerraExampleAppServerInstance"
  }

  depends_on = [aws_security_group.basic-http-sg]
}
