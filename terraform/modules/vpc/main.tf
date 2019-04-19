data "aws_availability_zones" "zones" {}

resource "aws_vpc" "main_vpc" {
  cidr_block       = "${var.vpc_cidr_block}"

  tags = {
    Name = "${var.cluster_name}_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags = {
    Name = "${var.cluster_name}_gw"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = "${length(data.aws_availability_zones.zones.names)}"
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr_block, var.subnet_bytes, count.index)}"

  tags = {
    Name = "${var.cluster_name}_public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = "${length(data.aws_availability_zones.zones.names)}"
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr_block, var.subnet_bytes, count.index + length(data.aws_availability_zones.zones.names))}"  
  availability_zone = "${element(data.aws_availability_zones.zones.names, count.index)}"
 
  tags = {
    Name = "${var.cluster_name}_private_subnet"
  }
}

resource "aws_route_table" "rt_public" {
  count  = "${length(data.aws_availability_zones.zones.names)}"
  vpc_id = "${aws_vpc.main_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "${var.cluster_name}_public_rt"
  }
}
resource "aws_route_table" "rt_private" {
  count  = "${length(data.aws_availability_zones.zones.names)}"
  vpc_id = "${aws_vpc.main_vpc.id}"
}

resource "aws_route_table_association" "public_association" {
  count          = "${length(data.aws_availability_zones.zones.names)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.rt_public.*.id, count.index)}"
}

resource "aws_route_table_association" "private_association" {
  count          = "${length(data.aws_availability_zones.zones.names)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.rt_private.*.id, count.index)}"
}
