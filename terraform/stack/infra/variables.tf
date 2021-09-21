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
variable "vpc_id" {
  type = string
  description = "VPC Id to create resources in"
}
variable "lambda_subnet_id" {
  type = string
  description = "Subnet id for Lambda function"
}
variable "lambda_max_memory" {
  type = number
  # default = 800
  description = "Amount of Memory in MBs your Lambda Function can use at runtime"
}
variable "lambda_timeout" {
  type = number
  # default = 3
  description = "Amount of time your Lambda Function has to run in seconds."
}