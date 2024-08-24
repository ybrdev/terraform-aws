terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64"
    }
  }
  required_version = ">= 1.9.5"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.env == "prod" ? "Production" : "Development"
    }
  }
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "subnet_public_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.env}-subnet-public-a"
  }
}

resource "aws_subnet" "subnet_public_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = "${var.region}b"
  tags = {
    Name = "${var.env}-subnet-public-b"
  }
}

# Private Subnets
resource "aws_subnet" "subnet_private_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.env}-subnet-private-a"
  }
}

resource "aws_subnet" "subnet_private_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = "${var.region}b"
  tags = {
    Name = "${var.env}-subnet-private-b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-igw"
  }
}

# NAT Gateways
resource "aws_eip" "nat_eip_a" {
  domain = "vpc"
  tags = {
    Name = "${var.env}-nat-eip-a"
  }
}

resource "aws_eip" "nat_eip_b" {
  domain = "vpc"
  tags = {
    Name = "${var.env}-nat-eip-b"
  }
}

resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.subnet_public_a.id
  tags = {
    Name = "${var.env}-nat-gw-a"
  }
}

resource "aws_nat_gateway" "nat_gw_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = aws_subnet.subnet_public_b.id
  tags = {
    Name = "${var.env}-nat-gw-b"
  }
}

# Route Tables
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-rtb-public"
  }
}

resource "aws_route_table" "rtb_private_a" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-rtb-private-a"
  }
}

resource "aws_route_table" "rtb_private_b" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-rtb-private-b"
  }
}

resource "aws_route" "route_public_igw" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "route_private_nat_a" {
  route_table_id         = aws_route_table.rtb_private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_a.id
}

resource "aws_route" "route_private_nat_b" {
  route_table_id         = aws_route_table.rtb_private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_b.id
}

# Route Table Associations
resource "aws_route_table_association" "rta_public_a" {
  route_table_id = aws_route_table.rtb_public.id
  subnet_id      = aws_subnet.subnet_public_a.id
}

resource "aws_route_table_association" "rta_public_b" {
  route_table_id = aws_route_table.rtb_public.id
  subnet_id      = aws_subnet.subnet_public_b.id
}

resource "aws_route_table_association" "rta_private_a" {
  route_table_id = aws_route_table.rtb_private_a.id
  subnet_id      = aws_subnet.subnet_private_a.id
}

resource "aws_route_table_association" "rta_private_b" {
  route_table_id = aws_route_table.rtb_private_b.id
  subnet_id      = aws_subnet.subnet_private_b.id
}

resource "aws_vpc_endpoint" "vpc_endpoint_s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [
    aws_route_table.rtb_private_a.id,
    aws_route_table.rtb_private_b.id,
  ]
  tags = {
    Name = "${var.env}-vpce-s3"
  }
}