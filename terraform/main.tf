
# -------------------- AWS Provider --------------------
# Defines the cloud provider and region
provider "aws" {
  region = "ap-south-1" # Mumbai region
}

# -------------------- VPC --------------------
# Creates a Virtual Private Cloud
resource "aws_vpc" "aniketvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "prasadvpc"
  }
}

# -------------------- Subnet --------------------
# Public subnet inside the VPC
resource "aws_subnet" "anisubnet" {
  vpc_id                  = aws_vpc.aniketvpc.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true # Automatically assign public IP

  tags = {
    Name = "prasad1-a"
  }
}

# -------------------- Internet Gateway --------------------
# Allows internet access to VPC resources
resource "aws_internet_gateway" "aniketIGW" {
  vpc_id = aws_vpc.aniketvpc.id

  tags = {
    Name = "Prasad-Igw"
  }
}

# -------------------- Route Table --------------------
# Defines routing rules for internet access
resource "aws_route_table" "aniketRT" {
  vpc_id = aws_vpc.aniketvpc.id

  # Route all traffic to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aniketIGW.id
  }

  tags = {
    Name = "PrasadddRT"
  }
}

# -------------------- Route Table Association --------------------
# Associates subnet with route table
resource "aws_route_table_association" "Aniketasso" {
  subnet_id      = aws_subnet.anisubnet.id
  route_table_id = aws_route_table.aniketRT.id
}

# -------------------- Security Group --------------------
# Controls inbound and outbound traffic
resource "aws_security_group" "anikeetSG" {
  name   = "PrassadSG"
  vpc_id = aws_vpc.aniketvpc.id

  # Allow SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------- Key Pair --------------------
# Uses an existing public key for SSH access
resource "aws_key_pair" "anu" {
  key_name   = "terraprasad"
  public_key = file("terraprasad.pub")
}

# -------------------- EC2 Instance --------------------
# Launches an EC2 instance with user data script
resource "aws_instance" "aniketec2" {
  ami                    = "ami-09b041abcb4daa286"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.anisubnet.id
  vpc_security_group_ids = [aws_security_group.anikeetSG.id]
  key_name               = aws_key_pair.anu.key_name

  # Script to install/configure web server
  user_data = file("web.sh")

  tags = {
    Name = "automation"
  }
}

# -------------------- Output --------------------
# Displays public IP after deployment
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.aniketec2.public_ip
}
```
