# Security Group for Frontend (Web Server)
resource "aws_security_group" "frontend" {
  name        = "frontend-sg"
  description = "Security group for frontend web server"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP inbound
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }

  # Allow HTTPS inbound
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  }

  # Allow SSH inbound
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict to your IP
    description = "Allow SSH access"
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.project_tags,
    {
      Name = "devops-project-frontend-sg"
    }
  )
}

# Security Group for Backend Server
resource "aws_security_group" "backend" {
  name        = "backend-sg"
  description = "Security group for backend server"
  vpc_id      = aws_vpc.main.id

  # Allow API traffic from frontend
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
    description     = "Allow API traffic from frontend"
  }

  # Allow SSH inbound
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict to your IP or bastion host
    description = "Allow SSH access"
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.project_tags,
    {
      Name = "devops-project-backend-sg"
    }
  )
}
