variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC"
}

variable "public_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the public subnet"
}

variable "private_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the private subnet"
}

variable "igw" {
  type        = string
  description = "Name tag for the igw"
}

variable "rtb" {
  type        = string
  description = "Name tag for the rtb"
}

