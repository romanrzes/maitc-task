resource "aws_vpc" "kitten_vpc" {
  enable_dns_hostnames = "${var.true_value}"
  cidr_block           = "${var.vpc_cidr}"

  tags = {
    Name                                   = "${var.aws_vpc_name}",
    "kubernetes.io/cluster/kitten-cluster" = "${var.k8s_io_tag}",
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.kitten_vpc.id}"

  tags = {
    Name = "${var.aws_ig_name}"
  }
}


resource "aws_eip" "nat" {
  vpc = "${var.true_value}"
}

/*
  Public Subnet
*/
resource "aws_subnet" "eu-central-1-public" {
  vpc_id                  = "${aws_vpc.kitten_vpc.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  availability_zone       = "${var.az}a"
  map_public_ip_on_launch = true

  tags = {
    Name                                   = "${var.pub_sub_name}"
    "kubernetes.io/cluster/kitten-cluster" = "${var.k8s_io_tag}"
  }
}

resource "aws_subnet" "eu-central-2-public" {
  vpc_id                  = "${aws_vpc.kitten_vpc.id}"
  cidr_block              = "${var.public_subnet_cidr2}"
  availability_zone       = "${var.az}b"
  map_public_ip_on_launch = "${var.true_value}"

  tags = {
    Name                                   = "${var.pub_sub_name}"
    "kubernetes.io/cluster/kitten-cluster" = "${var.k8s_io_tag}"
  }
}

resource "aws_route_table" "eu-central-2-public" {
  vpc_id = "${aws_vpc.kitten_vpc.id}"

  route {
    cidr_block = "${var.cidr_block_all}"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "${var.pub_sub_name}"
  }
}

resource "aws_route_table_association" "eu-central-2-public" {
  subnet_id      = "${aws_subnet.eu-central-2-public.id}"
  route_table_id = "${aws_route_table.eu-central-2-public.id}"
}

resource "aws_route_table" "eu-central-1-public" {
  vpc_id = "${aws_vpc.kitten_vpc.id}"

  route {
    cidr_block = "${var.cidr_block_all}"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "${var.pub_sub_name}"
  }
}

resource "aws_route_table_association" "eu-central-1-public" {
  subnet_id      = "${aws_subnet.eu-central-1-public.id}"
  route_table_id = "${aws_route_table.eu-central-1-public.id}"
}

resource "aws_security_group" "tf-eks-node" {
  name        = "terraform-eks-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.kitten_vpc.id}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_block_all}"]
  }
  tags = {
    Name = "terraform-eks-node"
  }
}

resource "aws_security_group" "tf-eks-master" {
  name        = "terraform-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.kitten_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_block_all}"]
  }

  tags = {
    Name = "terraform-eks-master"
  }
}
