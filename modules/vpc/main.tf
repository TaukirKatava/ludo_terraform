#Creating VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}

#Creating Public Subnet1a
resource "aws_subnet" "public-subnet-1a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public-subnet-1a-cidr-block
    availability_zone = var.subnet_az1a
    map_public_ip_on_launch = true

    tags = {
    "Name" = "public-subnet-1a-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}

#Creating Public Subnet1b
resource "aws_subnet" "public-subnet-1b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public-subnet-1b-cidr-block
    availability_zone = var.subnet_az1b
    map_public_ip_on_launch = true

    tags = {
    "Name" = "public-subnet-1b-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}

#Creating Public Subnet1c
resource "aws_subnet" "public-subnet-1c" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public-subnet-1c-cidr-block
    availability_zone = var.subnet_az1c
    map_public_ip_on_launch = true

    tags = {
    "Name" = "public-subnet-1c-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}


#Creating Private Subnet1a
resource "aws_subnet" "private-subnet-1a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private-subnet-1a-cidr-block
    availability_zone = var.subnet_az1a
    map_public_ip_on_launch = false
    
    tags = {
    "Name" = "private-subnet-1a-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}

#Creating Private Subnet1b
resource "aws_subnet" "private-subnet-1b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private-subnet-1b-cidr-block
    availability_zone = var.subnet_az1b
    map_public_ip_on_launch = false
    
    tags = {
    "Name" = "private-subnet-1b-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}


#Creating Internet Gateway for Public Subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "igw-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}

#Creating EIP for NAT gateway
resource "aws_eip" "eip" {
  domain   = "vpc"
  tags = {
    "Name" = "eip-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}

#Creating NAT gateway for Private Subnets
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet-1a.id

  tags = {
    "Name" = "nat-gateway-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [ aws_eip.eip, aws_subnet.public-subnet-1a ]
}

#Creating public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "public-rt-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}

#Creating private route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    "Name" = "private-rt-${var.project_name}"
    "Terraform" = "Yes"
    "MaagedBy" = "Yudiz"
    "Mode" = "common"
  }
}

#Creating public subnet association
resource "aws_route_table_association" "public-subnet-association" {
  route_table_id = aws_route_table.public-rt.id
  for_each = {
    "public-subnet-1a" = aws_subnet.public-subnet-1a.id
    "public-subnet_1b" = aws_subnet.public-subnet-1b.id
    "public-subnet_1c" = aws_subnet.public-subnet-1c.id
  }
  subnet_id = each.value
}

#Creating private subnet association
resource "aws_route_table_association" "private-subnet-association" {
  route_table_id = aws_route_table.private-rt.id
  for_each = {
    "private-subnet-1a" = aws_subnet.private-subnet-1a.id
    "private-subnet_1b" = aws_subnet.private-subnet-1b.id
  }
  subnet_id = each.value
}