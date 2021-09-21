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
variable "s3_domain_bucket_name" {
    type        = string
    description = "Domain name of the website for cloud front"
}
variable "is_ipv6_enabled" {
  type        = bool
  default     = false
  description = "true if ipv6 is enable for Cloudfront, false otherwise"
}
variable "default_root_object" {
    type        = string
    default     = "index.html"
    description = "Default root page for Cloudfront"
}
variable "logging_bucket" {
  type        = string
  description = "S3 bucket to store the logs of cloudfront"
}
variable "cookies_in_logs" {
    type        = bool
    description = "true to include cookies in logs, false otherwise" 
}
variable "s3_bucket_log_prefix" {
  type        = string
  default     = "cf-logs"
  description = "S3 prefix (folder) to store in "
}
variable "cf_alias" {
    type        = string
    default     = ""
    description = "User friendly Domain name to point to cloud front, leave empty if not required" 
}
variable "forward_query_string_to_origin" {
    type        = bool
    default     = false
    description = "true to forward query string to origin, false otherwise"
}
variable "forward_header_to_origin" {
    type        = list(string)
    default     = [ "Origin" ]
    description = "headers to vary upon for the cache behavior, * for all and leave empty if not required"  
}
variable "cokkies_to_forward" {
    type           = string
    default        = "none"
    /* allowed_values = ["all", "none", "whitelist"] */
    description    = "Specifies whether you want CloudFront to forward cookies to the origin"
}
variable "whitelisted_cookies_to_forward" {
  type        = list(string)
  default     = [ "" ]
  description = "(Only provide if cokkies_to_forward is whitelist) List of whitelisted cookies to forward"
}
variable "viewer_protocol_policy" {
    type           = string
    default        = "allow-all"
    /* allowed_values = ["allow-all", "https-only", "redirect-to-https"] */
    description    = "protocol that users can use to access the cloudfront"
}
variable "min_ttl" {
    type    = number
    default = 0
}
variable "default_ttl" {
    type    = number
    default = 3600
}
variable "max_ttl" {
    type    = number
    default = 86400
}
variable "price_class" {
    type           = string
    default        = "PriceClass_200"
    /* allowed_values = [PriceClass_All, PriceClass_200, PriceClass_100] */
    description    = "Price class for the cloudfront distribution"
}
variable "geo_restriction_type" {
    type           = string
    default        = "none"
    /* allowed_values = [none, whitelist, blacklist] */
    description    = "Type of geo restriction for the content"
}
variable "geo_locations" {
    type        = list(string)
    default     = [ "US", "CA", "GB", "DE"]
    description = "(Not required if geo_restriction_type is none) Geo location for restriction"  
}
variable "acm_certificate_arn" {
    type        = string
    default     = ""
    description = "Arn of ACM certificate to use, leave empty if not required"
}
variable "tags" {
  type = map(string)
  description = "Tags to attach to resources"
}