terraform {
  backend "s3" {
    bucket = "talk-terraform-tfs"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  availability_zone = var.availability_zone

  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "HelloWorld"
  }
}
