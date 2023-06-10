#-----------------------VPC------------------------------------

resource "aws_vpc" "vpc" {

  cidr_block    = var.vpc-cidr

  tags = {
    Name = var.vpc-name
  }
  
}


#----------------------Subnets--------------------------------


resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.vpc.id

  count = length(var.private-subnet-cider)
  cidr_block = var.private-subnet-cider[count.index]
  availability_zone = var.AZ[count.index]

  tags = {
    Name = var.private-subnet-tag-names[count.index]
  }

}

resource "aws_subnet" "pub-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub-subnet-cider
  availability_zone = var.AZ[1]

  tags = {
    Name = var.pub-subnet-tag-name
  }
}



#--------------------Nat and igW--------------------------


resource "aws_eip" "e-ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  subnet_id= aws_subnet.pub-subnet.id
  allocation_id = aws_eip.e-ip.id
  
  tags = {
    Name = var.nat-name
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw-id"
  }
}


#-----------------------------------route tables ------------------

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route-cider[0]
    gateway_id = aws_internet_gateway.gw.id
  }
  


  tags = {
    Name = "pub-rt"
  }

}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route-cider[0]
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  

 
  tags = {
    Name = "private-rt"
  }

}





#--------------------route table association-----------------------------


resource "aws_route_table_association" "private" {
  count = length(var.private-subnet-cider)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.pub-subnet.id
  route_table_id = aws_route_table.pub-rt.id
}
