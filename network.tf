
#variable "vpc_id" = {}


# declare a VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags {
    Name = "${var.name}-vpc"
  }

}
resource "aws_subnet" "public_subnet" {
  # vpc_id     = "${aws_vpc.nh_vpc.id}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count      = "${length(var.public_subnet_cidr)}"
  map_public_ip_on_launch = true
  lifecycle { create_before_destroy = true }
  tags {
    Name = "public_subnet_${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count      = "${length(var.private_subnet_cidr)}"

  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(var.private_subnet_cidr, count.index)}"

  availability_zone = "${element(var.availability_zones, count.index)}"
  lifecycle { create_before_destroy = true }
  tags {
    Name = "private_subnet_${count.index}"
  }
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "IGW"
  }
}

## Nat Gateway 
resource "aws_eip" "nat_eip" {
  count = "${ length(var.availability_zones)}"
  vpc      = true
}

resource "aws_nat_gateway" "natgw" {
  
  count = "${ length(var.availability_zones)}"
  #subnet_id     = "${element(aws_subnet.public_subnet.*.id, 1)}"

  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, count.index)}"

  depends_on = ["aws_internet_gateway.igw"]
  lifecycle { create_before_destroy = true }
}


resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }

    tags {
        Name = "Public Subnet Route Table"
    }
    lifecycle { create_before_destroy = true }
}

resource "aws_route_table_association" "public" {
    
    subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
    #count = "${length(aws_subnet.public_subnet.*.id)}"
    count = "${length(var.availability_zones)}"
    lifecycle { create_before_destroy = true }
}


resource "aws_route_table" "private" {
    count = "${length(var.availability_zones)}"
    vpc_id = "${aws_vpc.vpc.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
    }
    lifecycle { create_before_destroy = true }
    tags {
        Name = "Private Subnet Route Table"
    }
}

resource "aws_route_table_association" "private" {
    
    subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
    #count = "${length(aws_subnet.private_subnet.*.id)}"
    count = "${length(var.availability_zones)}"
    lifecycle { create_before_destroy = true }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_sg"
  description = "Allow SSH inbound connections"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  
}
