variable "aws_region" {
  description = "Region của AWS để triển khai các tài nguyên"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block cho VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block cho Public Subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block cho Private Subnet"
  default     = "10.0.2.0/24"
}

variable "ami_id" {
  description = "AMI ID để tạo EC2 instance"
  default     = "ami-12345678"  # Thay thế bằng AMI ID phù hợp
}

variable "key_name" {
  description = "Tên của key pair để truy cập vào EC2"
}

variable "your_ip" {
  description = "Địa chỉ IP của bạn để cho phép truy cập SSH vào Public EC2"
}
