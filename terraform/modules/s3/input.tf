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
variable "s3_bucket_name" {
  type = string
  description = "Name of the s3 bucket to create"
}
variable "s3_logs_bucket_name" {
  type        = string
  description = "Name of the logs bucket"
}
variable "s3_versioning" {
  type = bool
  default = true
  description = "true to enable S3 versioning, false otherwise"
}
variable "website_index_page" {
  type = string
  default = "index.html"
  description = "Path of index page for S3 website"
}
variable "website_error_page" {
  type = string
  default = "error.html"
  description = "Path of Error page for S3 website"
}
variable "redirect_all_requests_to" {
  default = ""
  
}
variable "tags" {
  type = map(string)
  description = "Tags to attach to resources"
}