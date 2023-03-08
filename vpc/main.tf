resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block = var.public_subnet_cidr_block
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  cidr_block = var.private_subnet_cidr_block
  vpc_id     = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-private-subnet"
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}
