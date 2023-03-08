resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_internet_gateway_attachment" "igwa" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.vpc.id
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

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "${var.vpc_name}-public_rtb"
  }
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.vpc_name}-natgw"
  }


  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }


  tags = {
    Name = "${var.vpc_name}-private_rtb"
  }
}

resource "aws_route_table_association" "public" {
  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "private" {
  gateway_id     = aws_nat_gateway.natgw.id
  route_table_id = aws_route_table.public_rtb.id
}
