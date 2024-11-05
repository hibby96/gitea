#THIS IS THE EXACT TERRAFORM USED TO CREATE THE VPC/SUBNET FOR THE GITEA SERVER MODULE, USE FOR REFERENCE

provider "aws" {
    region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "bucket_name" # s3 bucket where you want to store state files
    key    = "vpc/terraform.tfstate" #where the state file wil be kept
    region = "us-east-2"
  }
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my_vpc_name"
  }
}

resource "aws_subnet" "my_public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}


resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my_route_table"
  }
}

resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}