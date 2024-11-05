data "aws_ami" "al2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }
}

data "aws_vpc" "my_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "my_public_subnet" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
  vpc_id = data.aws_vpc.my_vpc.id
}

data "http" "my_ip" {
  url = "http://ipinfo.io/ip"
}