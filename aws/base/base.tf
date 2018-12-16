# Specify the provider and access details
provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraform"
}

# Create a VPC to launch our instances into aws
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "My VPC"
  }
}

# Create an internet gateway to give our subnet access to the outside world
# and assign vpc
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "My Internet Gateway"
  }
}

# Create a public subnet to launch our control plane
resource "aws_subnet" "public_sub" {
  vpc_id     = "${aws_vpc.default.id}"
  cidr_block = "10.0.1.0/24"
  tags {
    Name = "My Public Subnet"
  }
}


# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

#Associate public subnet for internet access
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.public_sub.id}"
  route_table_id = "${aws_vpc.default.main_route_table_id}"
}

# Create a private subnet to launch our data plane
resource "aws_subnet" "private_sub" {
  vpc_id     = "${aws_vpc.default.id}"
  cidr_block = "10.0.2.0/24"

  tags {
    Name = "My Private Subnet"
  }
}
