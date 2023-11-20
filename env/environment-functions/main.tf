provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zone
  cidr_block        = var.cidr_block_subnet

  tags = {
    Name = "Main"
  }
}

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_eip" "lb" {
  count = var.attach_eip ? 1 : 0

  instance = aws_instance.web.id
  vpc      = true
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group_rule" "sg-rule" {
  count             = length(var.ports-range)
  type              = "ingress"
  from_port         = var.ports-range[count.index]
  to_port           = var.ports-range[count.index]
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.sg.id
}

