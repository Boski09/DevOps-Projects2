data "aws_region" "aws-region" {}

locals {
  tags = {
    "Application Service Number" = "APP0005852"
    "Business Application Number" = "APM0001866"
    "Application Name" = "Ignite"
    "Environment name" = "${terraform.workspace}"
  }
  lambda_env_vars = {}
  
}

terraform {
  backend "s3" {
    bucket         = "proj-dev-tf-backend-us-west-2-193526802725"
    key            = "tf-state/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "proj-dev-tf-lock-us-west-2"
    encrypt        = true
  }
}

# module "vpc" {
#   source              = "../../modules/vpc"

#   vpc_cidr            = "10.0.0.0/16"
#   az_list             = ["us-west-2a","us-west-2b"]
#   vpc_tenancy         =  "default"
#   public_subnet_cidr  = ["10.0.1.0/24" , "10.0.2.0/24"]
#   private_subnet_cidr = ["10.0.6.0/24" , "10.0.7.0/24"]
#   tags                = local.tags
# }

# module "s3_bucket" {
#   source              = "../../modules/s3/"
#   project             = var.project
#   env                 = "${terraform.workspace}"
#   s3_bucket_name      = "${var.project}-${terraform.workspace}-cloudfront-${data.aws_region.aws-region.name}"
#   s3_logs_bucket_name = "${var.project}-${terraform.workspace}-cf-logs-${data.aws_region.aws-region.name}"
#   s3_versioning       = true
#   tags                = local.tags

# }
# module "cloudfront" {
#   source                         = "../../modules/cloudfront"
#   depends_on                     = [module.s3_bucket]
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   s3_domain_bucket_name          = module.s3_bucket.s3_bucket
#   is_ipv6_enabled                = true
#   default_root_object            = "index.html"
#   logging_bucket                 = module.s3_bucket.s3_logs_bucket
#   s3_bucket_log_prefix           = "cf-logs"
#   cookies_in_logs                = true
#   cf_alias                       = ""
#   forward_query_string_to_origin = false
#   forward_header_to_origin       = []
#   cokkies_to_forward             = "all"
#   whitelisted_cookies_to_forward = [""]
#   viewer_protocol_policy         = "redirect-to-https"
#   min_ttl                        = 0
#   default_ttl                    = 3600
#   max_ttl                        = 86400
#   price_class                    = "PriceClass_200"
#   geo_restriction_type           = "none"
#   geo_locations                  = [""]
#   acm_certificate_arn            = ""
#   tags                           = local.tags
  
# }

module "lambda_getlookupdata" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                      = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-bizparty-getlookupdata"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = "dotnetcore3.1"
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  tags                           = local.tags
  
}
module "lambda_getchargetypes" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                      = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-getchargetypes"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = "dotnetcore3.1"
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  tags                           = local.tags
  
}
# module "lambda_deletehoachargeitem" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-deletehoachargeitem"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_gethoacharge" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-gethoacharge"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_getindividualhoacharge" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-getindividualhoacharge"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_updatehoadues" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoadues"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_updatehoaentity" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoaentity"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_updatehoaproration" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoaproration"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_createhoacharge" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-createhoacharge"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_createhoachargeitem" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-createhoachargeitem"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_updatehoachargeitem" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoachargeitem"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_createsigningorder" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-createsigningorder"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_getpropertyaddress" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-getpropertyaddress"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_deletesigningorder" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-deletesigningorder"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_getsigningorder" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-getsigningorder"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
# }
# module "lambda_signingorderlist" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-signingorderlist"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
# module "lambda_updatesigningorder" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                      = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-updatesigningorder"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
#   lambda_function_runtime        = "dotnetcore3.1"
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
  
# }
