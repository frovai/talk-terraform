variable "region" {
  type    = string
  default = "us-east-1"
}

variable "availability_zone" {
  default = "us-east-1a"
}

### VPC variables ###

variable "cidr_block" {
  default = "10.0.0.0/16"
}

### Subnet variables ###
variable "cidr_block_subnet" {
  default = "10.0.1.0/24"
}

### Security group variables ###

### EC2 variables ### 
variable "ami" {
  type    = string
  default = "ami-052efd3df9dad4825"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ports-range" {
  description = "List of ports to add on the security group"
  type        = list(any)
  default     = ["22", "80", "443", "10050", "10051"]
}

variable "attach_eip" {
  type    = bool
  default = true
}