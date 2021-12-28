# production VPC

resource "aws_vpc" "Prod_Vpc" {
  cidr_block           = var.main_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "Prod_Vpc"
  }

}

# 2 Public subnets
resource "aws_subnet" "Prod_public_subnet1" {
  vpc_id            = aws_vpc.Prod_Vpc.id
  cidr_block        = var.public_cidr1
  availability_zone = "eu-west-2a"

  tags = {
    names = "Prod_public_subnet1"
  }
}

resource "aws_subnet" "Prod_public_subnet2" {
  vpc_id            = aws_vpc.Prod_Vpc.id
  cidr_block        = var.public_cidr2
  availability_zone = "eu-west-2b"

  tags = {
    names = "Prod_public_subnet2"
  }
}

# 2 Private Subnets (Databases)

resource "aws_subnet" "Prod_private_subnet1" {
  vpc_id            = aws_vpc.Prod_Vpc.id
  cidr_block        = var.private_cidr1
  availability_zone = "eu-west-2a"

  tags = {
    names = "Prod_private_subnet1"
  }
}



resource "aws_subnet" "Prod_private_subnet2" {
  vpc_id            = aws_vpc.Prod_Vpc.id
  cidr_block        = var.private_cidr2
  availability_zone = "eu-west-2b"

  tags = {
    names = "Prod_private_subnet2"
  }
}



# Public Route Route

resource "aws_route_table" "Prod_Public_RT" {
  vpc_id = aws_vpc.Prod_Vpc.id

  tags = {
    name = "Prod_Public_RT"
  }

}

# Associate the public Route table with the Public Subnets

resource "aws_route_table_association" "Public_Route_Association1" {
  route_table_id = aws_route_table.Prod_Public_RT.id
  subnet_id      = aws_subnet.Prod_public_subnet1.id

}

resource "aws_route_table_association" "Public_Route_Association2" {
  route_table_id = aws_route_table.Prod_Public_RT.id
  subnet_id      = aws_subnet.Prod_public_subnet2.id

}


# Private Route Route

resource "aws_route_table" "Prod_Private_RT" {
  vpc_id = aws_vpc.Prod_Vpc.id

  tags = {
    name = "Prod_Private_RT"
  }

}

# Associate the private Route table with the Private Subnets

resource "aws_route_table_association" "Private_Route_Association1" {
  route_table_id = aws_route_table.Prod_Private_RT.id
  subnet_id      = aws_subnet.Prod_private_subnet1.id

}

resource "aws_route_table_association" "Private_Route_Association2" {
  route_table_id = aws_route_table.Prod_Private_RT.id
  subnet_id      = aws_subnet.Prod_private_subnet2.id

}

# Internet Gate to allow internet into public

resource "aws_internet_gateway" "Prod_IGW" {
  vpc_id = aws_vpc.Prod_Vpc.id

  tags = {
    name = "Prod_IGW"
  }

}

# Associate IGW with the public Route table

resource "aws_route" "Assoc_IGW_with_Routetable" {
  route_table_id         = aws_route_table.Prod_Public_RT.id
  gateway_id             = aws_internet_gateway.Prod_IGW.id
  destination_cidr_block = var.destination_cidr
}

# Elastic IP

resource "aws_eip" "EIP_for_NG" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.3"
  depends_on                = [aws_internet_gateway.Prod_IGW]

}

# Nat Gateway for internet through the public Subnet

resource "aws_nat_gateway" "Prod_NG" {
  allocation_id = aws_eip.EIP_for_NG.id
  subnet_id     = aws_subnet.Prod_public_subnet1.id
  depends_on    = [aws_eip.EIP_for_NG]

}
# Route NAT GW with private Route table
resource "aws_route" "NatGW-association_with-private_RT" {
  route_table_id         = aws_route_table.Prod_Private_RT.id
  nat_gateway_id         = aws_nat_gateway.Prod_NG.id
  destination_cidr_block = var.destination_cidr

}

