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
#################################
#        Cloud front vars       #
#################################
variable "vpc_id" {
  type = string
  description = "VPC Id to create resources in"
}
variable "lambda_subnet_ids" {
  type = list(string)
  description = "One or more Subnet id for Lambda function"
}
variable "lambda_function_runtime" {
    type = string
    description = "Lambda function runtime e.g python3.9"  
}
variable "lambda_max_memory" {
  type = number
  description = "Amount of Memory in MBs your Lambda Function can use at runtime"
}
variable "lambda_timeout" {
  type = number
  description = "Amount of time your Lambda Function has to run in seconds."
}

########Per Lambda vars #######

variable "lambda_layer_01_deployment_pkg_path"{
  type = string
  description = "(Empty if not required) Lambda function layer code zip local path"
}

variable "getlookupdata_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "getlookupdata_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}

variable "getchargetypes_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "getchargetypes_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "deletehoachargeitem_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "deletehoachargeitem_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "gethoacharge_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "gethoacharge_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "getindividualhoacharge_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "getindividualhoacharge_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "updatehoadues_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "updatehoadues_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "updatehoaentity_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "updatehoaentity_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "updatehoaproration_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "updatehoaproration_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "createhoacharge_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "createhoacharge_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "createhoachargeitem_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "createhoachargeitem_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "updatehoachargeitem_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "updatehoachargeitem_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "createsigningorder_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "createsigningorder_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "getpropertyaddress_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "getpropertyaddress_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "deletesigningorder_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "deletesigningorder_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "getsigningorder_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "getsigningorder_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}

variable "signingorderlist_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "signingorderlist_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "updatesigningorder_lambda_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "updatesigningorder_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}

#################################
#        S3 bucket vars         #
#################################
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


#################################
#        Cloud front vars       #
#################################
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


#################################
#           API vars            #
#################################

variable "api_lambda_01_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "api_lambda_01_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "api_lambda_02_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "api_lambda_02_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "api_lambda_03_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "api_lambda_03_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "api_lambda_04_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "api_lambda_04_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "api_lambda_05_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "api_lambda_05_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "api_lambda_06_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "api_lambda_06_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
}
variable "api_lambda_authorizer_handler_name" {
  type = string
  description = "Lambda function handler name"
}
variable "api_lambda_authorizer_lambda_deployment_package_path" {
    type = string
    description = "Lambda function code zip local path"
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

#################################
#           DynamoDB            #
#################################
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