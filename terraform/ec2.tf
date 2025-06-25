# Frontend EC2 Instance (Web Server)
resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.frontend_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.frontend.id]
  key_name               = var.ssh_key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Frontend server is running" > /var/www/html/index.html
              EOF

  tags = merge(
    var.project_tags,
    {
      Name = "devops-project-frontend"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

# Backend EC2 Instance
resource "aws_instance" "backend" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.backend_instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.backend.id]
  key_name               = var.ssh_key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nodejs npm
              echo "Backend server is ready for configuration" > /home/ec2-user/backend-ready.txt
              EOF

  tags = merge(
    var.project_tags,
    {
      Name = "devops-project-backend"
    }
  )

  depends_on = [aws_nat_gateway.nat_gw]
}

# Elastic IP for Frontend
resource "aws_eip" "frontend" {
  instance = aws_instance.frontend.id
  vpc      = true

  tags = merge(
    var.project_tags,
    {
      Name = "devops-project-frontend-eip"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}
