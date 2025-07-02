
resource "aws_security_group" "frontend" {
  name        = "frontend-sg"
  description = "Security group for frontend web server"
  vpc_id      = aws_vpc.main.id


#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow HTTP traffic"
#   }


#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow HTTPS traffic"
#   }


#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  
#     description = "Allow SSH access"
#   }


#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }

#   tags = merge(
#     var.project_tags,
#     {
#       Name = "devops-project-frontend-sg"
#     }
#   )
# }

# resource "aws_security_group" "backend" {
#   name        = "backend-sg"
#   description = "Security group for backend server"
#   vpc_id      = aws_vpc.main.id


#   ingress {
#     from_port   = 3000
#     to_port     = 3000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow API traffic from public internet (since we're using a single instance)"
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] 
#     description = "Allow SSH access"
#   }


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


##jack