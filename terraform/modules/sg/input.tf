variable "project" {
  type = string
  default = "proj"
  description = "Project name"
}
variable "env" {
  type = string
  default = "cert"
  description = "Environment name"
}
variable "vpc_id" {
  type        = string
  description = "Vpc id"
}