resource "aws_vpc" "eks-vpc" {
  cidr_block = var.cidr_block_vpc
  instance_tenancy = "default"
  tags = {
    Name = "eks-vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "public-subnet-01" {
  vpc_id = aws_vpc.eks-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "public-subnet-01"
  }
}

resource "aws_subnet" "public-subnet-02" {
  vpc_id = aws_vpc.eks-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-1c"
  tags = {
    Name = "public-subnet-02"
  }
}

resource "aws_subnet" "private-subnet-01" {
  vpc_id = aws_vpc.eks-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"  
  tags = {
    Name = "private-subnet-02"
  } 
}

resource "aws_subnet" "private-subnet-02" {
  vpc_id = aws_vpc.eks-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-1c"
  tags = {
    Name = "private_subnet-02"
  }
}

resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.eks-vpc.id
  tags = {
    Name = "eks-igw"
  }
}

resource "aws_eip" "eip-nat" {
}

resource "aws_nat_gateway" "eks-nat-gw" {
  subnet_id = aws_subnet.public-subnet-01.id
  allocation_id = aws_eip.eip-nat.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks-vpc.id
  tags = {
    Name = "eks-vpc-public-route-table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.eks-vpc.id
  tags = {
    Name = "eks-vpc-private-route-table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-nat-gw.id
  }
}
# Associate private subnets with private route table
resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private-subnet-01.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      =  aws_subnet.private-subnet-02.id
  route_table_id = aws_route_table.private_route_table.id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public-subnet-01.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public-subnet-02.id
  route_table_id = aws_route_table.public_route_table.id
}