resource "aws_instance" "public_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_id
  security_groups = [var.public_sg_id]

  key_name = var.key_name

  tags = {
    Name = "Public EC2"
  }
}

resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_id
  security_groups = [var.private_sg_id]

  key_name = var.key_name

  tags = {
    Name = "Private EC2"
  }
}
