# 1 VPC

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "My VPC"
  }
}

# 2 PUBLIC SUBNET IN 2 AZ

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-3a"

  # avec la création d'une vm, assigne automatique l'adresse ip
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet eu-west-3a"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3b"

  # avec la création d'une vm, assigne automatique l'adresse ip
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet eu-west-3b"
  }
}

# # 2 PRIVATE SUBNET IN 2 AZ

# resource "aws_subnet" "private_1" {
#   vpc_id            = aws_vpc.my_vpc.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "eu-west-3a"


#   tags = {
#     Name = "Public Subnet eu-west-3a"
#   }
# }

# resource "aws_subnet" "private_2" {
#   vpc_id            = aws_vpc.my_vpc.id
#   cidr_block        = "10.0.3.0/24"
#   availability_zone = "eu-west-3b"


#   tags = {
#     Name = "Public Subnet eu-west-3b"
#   }
# }

# 1 INTERNET_GATEWAY

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

# 1 ROUTE TABLE CONNECTING THE 2 PUBLIC SUBNET

resource "aws_route_table" "my_vpc_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_igw.id
  }

  tags = {
    Name = "Public Subnets Route Table for My VPC"
  }
}

resource "aws_route_table_association" "my_vpc_us_east_1a_public" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.my_vpc_public.id
}

resource "aws_route_table_association" "my_vpc_us_east_1b_public" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.my_vpc_public.id
}