provider "aws" {
  region = var.aws_region  # Sử dụng biến từ variables.tf
}

# Tạo VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Main VPC"
  }
}

# Tạo Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true  # Đảm bảo EC2 trong Public Subnet có IP công khai

  tags = {
    Name = "Public Subnet"
  }
}

# Tạo Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "Private Subnet"
  }
}

# Tạo Internet Gateway cho VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet Gateway"
  }
}

# Tạo Public Route Table cho Public Subnet (kết nối qua Internet Gateway)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Gán Public Subnet vào Public Route Table
resource "aws_route_table_association" "public_route_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Tạo Elastic IP cho NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

# Tạo NAT Gateway cho Private Subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "NAT Gateway"
  }
}

# Tạo Private Route Table cho Private Subnet (kết nối qua NAT Gateway)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Gán Private Subnet vào Private Route Table
resource "aws_route_table_association" "private_route_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Tạo Default Security Group cho VPC (chỉ cho phép truy cập trong nội bộ VPC)
resource "aws_security_group" "default_sg" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Default SG"
  }
}

# Tạo Security Group cho Public EC2 (chỉ cho phép kết nối SSH từ IP cụ thể)
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public EC2 SG"
  }
}

# Tạo Security Group cho Private EC2 (chỉ cho phép SSH từ Public EC2)
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private EC2 SG"
  }
}

# Tạo Public EC2 instance
resource "aws_instance" "public_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public_sg.name]

  tags = {
    Name = "Public EC2"
  }

  key_name = var.key_name
}

# Tạo Private EC2 instance (chỉ truy cập qua Public EC2)
resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_sg.name]

  tags = {
    Name = "Private EC2"
  }

  key_name = var.key_name
}
