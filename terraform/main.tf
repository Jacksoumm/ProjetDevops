terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}


data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 1. Génère une clé SSH localement
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Ajoute la clé publique dans AWS
resource "aws_key_pair" "generated_key" {
  key_name   = "generated-ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# 3. Enregistre la clé privée sur le disque local
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/id_rsa"
  file_permission = "0600"
}

# 4. Instance EC2 (ex. frontend)
resource "aws_instance" "frontend" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.frontend_instance_type
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = merge(var.project_tags, {
    Name = "Frontend"
  })
}
