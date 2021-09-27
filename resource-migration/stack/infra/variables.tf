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
  default = "vpc-d53b0ead"
  description = "VPC Id to create resources in"
}
variable "lambda_subnet_ids" {
  type = list(string)
  default = [ "subnet-0b76e756","subnet-a03494ea" ]
  description = "One or more Subnet id for Lambda function"
}
variable "lambda_max_memory" {
  type = number
  default = 800
  description = "Amount of Memory in MBs your Lambda Function can use at runtime"
}
variable "lambda_timeout" {
  type = number
  default = 800
  description = "Amount of time your Lambda Function has to run in seconds."
}