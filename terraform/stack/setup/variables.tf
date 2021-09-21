variable "project" {
  type = string
  default = "proj"
  description = "Project name"
}
variable "env" {
  type = string
  default = "dev"
  description = "Environment name"
}
variable "s3_versioning" {
  type = bool
  default = true
  description = "true to enable S3 versioning, false otherwise"
}