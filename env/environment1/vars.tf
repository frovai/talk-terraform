variable "region" {
  type    = string
  default = "us-east-1"
}

### EC2 variables ### 
variable "ami" {
  type    = string
  default = "ami-052efd3df9dad4825"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type    = string
  default = "subnet-xxxxxxxxxxx"
}