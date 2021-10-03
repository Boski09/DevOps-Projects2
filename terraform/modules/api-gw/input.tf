variable "project" {
  type        = string
  default     = "ddms"
  description = "Project name"
}
variable "env" {
  type        = string
  default     = "dev"
  description = "Environment name"
}
variable "account_id"{
    type = string
    description = "AWS account id"
}
variable "region"{
    type = string
    description = "AWS region"
}
variable "stage_01_name"{
    type = string
    description = "API stage 01 name"
}
variable "stage_02_name"{
    type = string
    description = "API stage 02 name"
}
variable "api_01" {
    type = string
    description = "api name 01"
}
variable "api_02" {
    type = string
    description = "api name 02"
}
variable "api_03" {
    type = string
    description = "api name 03"
}
variable "api_04" {
    type = string
    description = "api name 04"
}
variable "api_05" {
    type = string
    description = "api name 05"
}
variable "api_06" {
    type = string
    description = "api name 05"
}
variable "api_07" {
    type = string
    description = "api name 05"
}
variable "api_08" {
    type = string
    description = "api name 05"
}
variable "enable_api_xray"{
    type = string
    default = true
    description = "Enable xray for api gateway"
}
variable "authorizer_lambda_invoke_arn"{
    type = string
    description = "Authorizer lambda invoke arn"
}
variable "lambda_invoke_arn_01"{
    type = string
    description = "Lambda 01 invoke arn "
}
variable "lambda_name_01"{
    type = string
    description = "Lambda 01 name "
}
variable "lambda_invoke_arn_02"{
    type = string
    description = "Lambda 02 invoke arn "
}
variable "lambda_name_02"{
    type = string
    default = ""
    description = "Lambda 02 name "
}
variable "lambda_invoke_arn_03"{
    type = string
    description = "Lambda 03 invoke arn "
}
variable "lambda_name_03"{
    type = string
    default = ""
    description = "Lambda 03 name "
}
variable "lambda_invoke_arn_04"{
    type = string
    description = "Lambda 04 invoke arn "
}
variable "lambda_name_04"{
    type = string
    default = ""
    description = "Lambda 04 name "
}
variable "lambda_invoke_arn_05"{
    type = string
    default = ""
    description = "Lambda 05 invoke arn "
}
variable "lambda_name_05"{
    type = string
    default = ""
    description = "Lambda 05 name "
}
variable "lambda_invoke_arn_06"{
    type = string
    default = ""
    description = "Lambda 06 invoke arn "
}
variable "lambda_name_06"{
    type = string
    default = ""
    description = "Lambda 01 name "
}
variable "tags"{
    type = map(string)
    description = "Tags for resources"
}