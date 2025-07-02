variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-3" 
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Private subnet removed to stay within Free Tier

variable "frontend_instance_type" {
  description = "EC2 instance type for the frontend server"
  type        = string
  default     = "t2.micro"  
}

variable "backend_instance_type" {
  description = "EC2 instance type for the backend server"
  type        = string
  default     = "t2.micro"  
}



variable "project_tags" {
  description = "Tags to apply to resources created by this module"
  type        = map(string)
  default = {
    Project     = "DevOps-Project"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}
