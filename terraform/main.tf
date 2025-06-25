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

# Use data source to get the latest Amazon Linux 2 AMI
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

# Store the state file in S3 (uncomment and configure for production use)
# terraform {
#   backend "s3" {
#     bucket = "your-terraform-state-bucket"
#     key    = "devops-project/terraform.tfstate"
#     region = "eu-west-3"
#     encrypt = true
#   }
# }
