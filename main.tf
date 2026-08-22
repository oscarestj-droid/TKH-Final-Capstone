terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ==========================================
# NETWORK ARCHITECTURE
# ==========================================

# Create the foundational Virtual Private Cloud
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "capstone-vpc"
  }
}

# Create a public subnet for the web server
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "capstone-public-subnet"
  }
}

# Create an Internet Gateway to allow external traffic
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "capstone-igw"
  }
}

# Route table redirecting all outbound internet traffic to the gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "capstone-public-route-table"
  }
}

# Associate the public subnet to the route table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ==========================================
# FIREWALL ARCHITECTURE
# ==========================================

resource "aws_security_group" "web_sg" {
  name        = "capstone-web-security-group"
  description = "Allow public HTTP traffic and restricted SSH admin access"
  vpc_id      = aws_vpc.main.id

  # Open HTTP access to the entire world
  ingress {
    description = "Allow public web access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Strictly lock down SSH to your home IP address variable
  ingress {
    description = "Restricted administrator SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_home_ip]
  }

  # Allow all outbound server traffic
  egress {
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
# SERVER ARCHITECTURE (COMPUTE)
# ==========================================

# Lookup the latest stable Amazon Linux 2023 AMI ID
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

  # Attach your secure firewall security group
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User data bootstrap script to deploy and launch Apache on launch
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Welcome to Titan FinTech Automated Web Stack</h1>" > /var/view/html/index.html
              EOF

  tags = {
    Name = "capstone-web-server"
  }
}
