resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy
  tags             = merge({"Name" = "${var.project}-${var.env}-vpc"}, var.tags)
}

resource "aws_subnet" "vpc_public_subnet" {
  count                   = length(var.az_list)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.az_list[count.index]
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet_cidr[count.index]
  tags  = merge({"Name" = "${var.project}-${var.env}-public-subnet-${count.index + 1}"}, var.tags)
}

resource "aws_subnet" "vpc_private_subnet" {
  count                   = length(var.az_list)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.az_list[count.index]
  cidr_block              = var.private_subnet_cidr[count.index]
  map_public_ip_on_launch = false
  tags  = merge({"Name" = "${var.project}-${var.env}-private-subnet-${count.index + 1}"}, var.tags)
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({"Name" = "${var.project}-${var.env}-igw"}, var.tags)
}

resource "aws_eip" "eip" {
  count = length(var.az_list)
  vpc   = true
}

resource "aws_nat_gateway" "vpc_nat_gw" {
  count         = length(var.az_list)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.vpc_public_subnet[count.index].id
  tags          = merge({"Name" = "${var.project}-${var.env}-nat-gw-${count.index + 1}"}, var.tags)
}

resource "aws_route_table" "vpc_public_rt" {
  count  = length(var.az_list)
  vpc_id = aws_vpc.vpc.id
  route  = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.vpc_igw.id
      carrier_gateway_id         = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      instance_id                = null
      ipv6_cidr_block            = null
      local_gateway_id           = null
      nat_gateway_id             = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
    }
  ]
  tags = merge({"Name" = "${var.project}-${var.env}-public-rt-${count.index + 1}"}, var.tags)
}

resource "aws_route_table" "vpc_private_rt" {
  count  = length(var.az_list)
  vpc_id = aws_vpc.vpc.id
  route  = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_nat_gateway.vpc_nat_gw[count.index].id
      carrier_gateway_id         = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      instance_id                = null
      ipv6_cidr_block            = null
      local_gateway_id           = null
      nat_gateway_id             = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
    }
  ]
  tags  = merge({"Name" = "${var.project}-${var.env}-private-rt-${count.index + 1}"},var.tags)
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.az_list)
  subnet_id      = aws_subnet.vpc_public_subnet[count.index].id
  route_table_id = aws_route_table.vpc_public_rt[count.index].id
}

resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.az_list)
  subnet_id      = aws_subnet.vpc_private_subnet[count.index].id
  route_table_id = aws_route_table.vpc_private_rt[count.index].id
}