variable "ami_id" {
  description = "AMI ID để tạo EC2 instance"
}

variable "key_name" {
  description = "Tên của key pair để truy cập vào EC2"
}

variable "public_subnet_id" {
  description = "ID của Public Subnet"
}

variable "private_subnet_id" {
  description = "ID của Private Subnet"
}

variable "public_sg_id" {
  description = "ID của Security Group cho Public EC2"
}

variable "private_sg_id" {
  description = "ID của Security Group cho Private EC2"
}
