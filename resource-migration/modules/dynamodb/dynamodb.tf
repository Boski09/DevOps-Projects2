resource "aws_dynamodb_table" "dynamo_table" {
  name         = var.dynamodb_table_name
  billing_mode = var.dynamo_billing_mode
  write_capacity = var.dynamo_billing_mode == "PROVISIONED" ? var.dynamo_write_capacity : null
  read_capacity =  var.dynamo_billing_mode == "PROVISIONED" ? var.dynamo_write_capacity : null
  hash_key     = var.hash_key
  range_key    = var.range_key != "" ? var.range_key : null
  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }
  attribute {
    name = var.range_key
    type = var.range_key_type
  }
  tags = var.tags
}