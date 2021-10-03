variable "project" {
  type = string
  default = "ddws"
  description = "Project name"
}
variable "env" {
  type = string
  default = "dev"
  description = "Environment name"
}
variable "region"{
    type = string
    description = "AWS region"
}
variable "dynamodb_table_name" {
    type = string
    description = "Dynamo DB table name"
}
variable "dynamo_billing_mode" {
    type = string
    default = "PROVISIONED"
    description = "DynamoDB billing mode PROVISIONED or PAY_PER_REQUEST"
}
variable "dynamo_write_capacity"{
    type = number
    default = 5
    description = "DyanoDB read capacity"
}
variable "dynamo_read_capacity"{
    type = number
    default = 10
    description = "DyanoDB read capacity"
}
variable "hash_key"{
    type = string
    description = "DynamoDB table hash key"
}
variable "hash_key_type"{
    type = string
    description = "DynamoDB table hash key type S, N or B"
}
variable "range_key"{
    type = string
    description =  "(Optional) DynamoDB table range key, Leave empty if not required"
}
variable "range_key_type"{
    type = string
    description = "DynamoDB table range key type S, N or B"
}
variable "tags"{
    type = map(string)
}