locals {
  azs         = var.availability_zones
  num_of_azs  = length(local.azs)
  nets_per_az = 3
  num_of_nets = local.num_of_azs * local.nets_per_az
  cidr_blocks = {
    for az in local.azs : az => {
      public_subnet = cidrsubnet(var.cidr, local.num_of_nets, local.nets_per_az * index(local.azs, az) + 1),
      app_subnet    = cidrsubnet(var.cidr, local.num_of_nets, local.nets_per_az * index(local.azs, az) + 2),
      db_subnet     = cidrsubnet(var.cidr, local.num_of_nets, local.nets_per_az * index(local.azs, az) + 3),
    }
  }
}

resource "aws_vpc" "vpc" {
  region     = var.region
  cidr_block = var.cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-internet-gateway"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = toset(local.azs)
  cidr_block              = local.cidr_blocks[each.key]["public_subnet"]
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet-${each.key}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public-subnet-route-table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each       = toset(local.azs)
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.vpc.id
  for_each          = toset(local.azs)
  cidr_block        = local.cidr_blocks[each.key]["app_subnet"]
  availability_zone = each.key

  tags = {
    Name = "${var.name}-app-subnet-${each.key}"
  }
}

resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-app-subnet-route-table"
  }
}

resource "aws_route_table_association" "app_route_table_association" {
  for_each       = toset(local.azs)
  subnet_id      = aws_subnet.app_subnet[each.key].id
  route_table_id = aws_route_table.app_route_table.id
}

resource "aws_subnet" "db_subnet" {
  vpc_id            = aws_vpc.vpc.id
  for_each          = toset(local.azs)
  cidr_block        = local.cidr_blocks[each.key]["db_subnet"]
  availability_zone = each.key

  tags = {
    Name = "${var.name}-db-subnet-${each.key}"
  }
}

resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-db-subnet-route-table"
  }
}

resource "aws_route_table_association" "db_route_table_association" {
  for_each       = toset(local.azs)
  subnet_id      = aws_subnet.db_subnet[each.key].id
  route_table_id = aws_route_table.db_route_table.id
}
