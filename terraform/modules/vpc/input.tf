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
variable "vpc_cidr" {
  type        = string
  description = "Vpc ip cidr block"
}
variable "az_list" {
  type = list(string)
  default = ["us-west-2a","us-west-2b","us-west-2c"]
  description = "Availibility zones to cover"
}
variable "vpc_tenancy" {
  type        = string
  default     = "default"
  description = "Vpc tenancy. default,dedicated or host"
}
variable "public_subnet_cidr" {
  type        = list(string)
  description = "public subnet ip cidr block"
}
variable "private_subnet_cidr" {
  type        = list(string)
  description = "private subnet ip cidr block"
}
variable "tags" {
  type = map(string)
  description = "Tags to attach to resources"
}