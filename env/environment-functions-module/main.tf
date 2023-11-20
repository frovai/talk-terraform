provider "aws" {
  region = var.region
}

module "dynamodb_table" {
  #source = "git::https://github.com/...../terraform-modules.git//dynamodb"

  source                         = "../../modules/dynamodb"
  name                           = var.name
  hash_key                       = var.hash_key
  range_key                      = var.range_key
  point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
  attributes                     = var.attributes
  tags                           = var.tags_dynamo
}