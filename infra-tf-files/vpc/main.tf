# Create VPC
resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "app_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "app_igw"
  }
}


# Create subnet 1
resource "aws_subnet" "app_subnet_1" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "app_subnet_1"
  }
}

# Create subnet 2
resource "aws_subnet" "app_subnet_2" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "app_subnet_2"
  }
}

# Create Route Table
resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name = "app_route_table"
  }
}

# Associate subnets with Route Table
resource "aws_route_table_association" "app_association_subnet_1" {
  subnet_id      = aws_subnet.app_subnet_1.id
  route_table_id = aws_route_table.app_route_table.id
}

resource "aws_route_table_association" "app_association_subnet_2" {
  subnet_id      = aws_subnet.app_subnet_2.id
  route_table_id = aws_route_table.app_route_table.id
}

