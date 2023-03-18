#////////////////////
# VPC
#////////////////////
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.app_name}-${local.environment}-vpc"
  }
}


#////////////////////
# Internet Gateway
#////////////////////
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${local.app_name}-${local.environment}-igw"
  }
}


#////////////////////
# Pubric Subnet
#////////////////////
resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "${local.app_name}-${local.environment}-public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "${local.app_name}-${local.environment}-public-1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1d"
  tags = {
    Name = "${local.app_name}-${local.environment}-public-1d"
  }
}

#////////////////////
# Public Route Table
#////////////////////
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${local.app_name}-${local.environment}-public"
  }
}


#////////////////////
# Public Route Table Association
#////////////////////
resource "aws_route_table_association" "public_1a_to_ig" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c_to_ig" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1d_to_ig" {
  subnet_id      = aws_subnet.public_1d.id
  route_table_id = aws_route_table.public.id
}


#////////////////////
# Private Subnet
#////////////////////
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "${local.app_name}-${local.environment}-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "${local.app_name}-${local.environment}-private-1c"
  }
}

resource "aws_subnet" "private_1d" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "ap-northeast-1d"
  tags = {
    Name = "${local.app_name}-${local.environment}-private-1d"
  }
}

