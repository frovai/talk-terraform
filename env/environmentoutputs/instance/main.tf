provider "aws" {
  region = var.region
}

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = data.terraform_remote_state.networking.outputs.subnet_id
  #subnet_id     = var.subnet_id

  tags = {
    Name = "HelloWorld"
  }
}