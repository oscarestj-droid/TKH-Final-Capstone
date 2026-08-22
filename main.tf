# ==========================================
# FIREWALL ARCHITECTURE (HARDENED WITH DESCRIPTION OVERRIDES)
# ==========================================

resource "aws_security_group" "web_sg" {
  name        = "capstone-web-security-group"
  description = "Allow public HTTP traffic and restricted SSH admin access"
  vpc_id      = aws_vpc.main.id

  # CRITICAL SECURITY FIX: Added explicit descriptions for every ingress/egress rule
  ingress {
    description = "Allow public web access to production frontend web application"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Restricted administrator SSH access restricted to corporate home office"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_home_ip]
  }

  egress {
    description = "Allow all outbound server traffic for updates and patches"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "capstone-web-sg"
  }
}

# ==========================================
# SERVER ARCHITECTURE (SECURED WITH DISK ENCRYPTION)
# ==========================================

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # CRITICAL SECURITY FIX: Enforce root volume encryption so the SAST scanner passes
  root_block_device {
    encrypted   = true
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Welcome to Titan FinTech Automated Web Stack</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "capstone-web-server"
  }
}
