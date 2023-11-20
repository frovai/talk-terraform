data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "talk-terraform-tfs"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}