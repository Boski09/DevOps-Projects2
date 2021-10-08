variable "project" {
  type        = string
  default     = "proj"
  description = "Project name"
}
variable "env" {
  type        = string
  default     = "dev"
  description = "Environment name"
}
variable "lambda_layer_name"{
  type = string
  description = "Lambda function layer name"
}
variable "lambda_layer_deployment_pkg_path"{
  type = string
  description = "(Empty if not required) Lambda function layer code zip local path"
}
variable "lambda_layer_runtime"{
  type = string
  description = "Lambda function layer runtime e.g dotnet3.1"
}