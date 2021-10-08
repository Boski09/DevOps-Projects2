data "aws_region" "aws-region" {}
data "aws_caller_identity" "current" {}


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
    key            = "tf-state2/terraform.tfstate"
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

#############################################
#               S3 bucket                   #
#############################################

module "s3_bucket" {
  source              = "../../modules/s3/"
  project             = var.project
  env                 = "${terraform.workspace}"
  s3_bucket_name      = "${var.project}-${terraform.workspace}-cloudfront-${data.aws_region.aws-region.name}"
  s3_logs_bucket_name = "${var.project}-${terraform.workspace}-cf-logs-${data.aws_region.aws-region.name}"
  s3_versioning       = true
  tags                = local.tags

}
#############################################
#             Cloud Front                   #
#############################################

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

#############################################
#             Lambda Functions              #
#############################################

module "lambda_getlookupdata" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-bizparty-getlookupdata"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-bizparty-getlookupdata"
  lambda_reserved_concurrency    = 20
  lambda_layer                   = module.lambda_layer_01[0].lambda_layer_arn
  
}
module "lambda_getchargetypes" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-getchargetypes"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.getchargetypes_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.getchargetypes_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-getchargetypes"
  lambda_reserved_concurrency    = 20
  lambda_layer                   = module.lambda_layer_01[0].lambda_layer_arn


}
module "lambda_deletehoachargeitem" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-deletehoachargeitem"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.deletehoachargeitem_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.deletehoachargeitem_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-deletehoachargeitem"
  
}
module "lambda_gethoacharge" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-gethoacharge"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.gethoacharge_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.gethoacharge_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-gethoacharge"
  
}
module "lambda_getindividualhoacharge" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-getindividualhoacharge"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.getindividualhoacharge_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.getindividualhoacharge_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-getindividualhoacharge"
  
}
module "lambda_updatehoadues" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoadues"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.updatehoadues_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.updatehoadues_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoadues"
  
}
module "lambda_updatehoaentity" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoaentity"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.updatehoaentity_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.updatehoaentity_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoaentity"
  
}
module "lambda_updatehoaproration" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoaproration"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.updatehoaproration_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.updatehoaproration_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoaproration"
  
}
module "lambda_createhoacharge" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-createhoacharge"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.createhoacharge_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.createhoacharge_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-createhoacharge"
  
}
module "lambda_createhoachargeitem" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-createhoachargeitem"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.createhoachargeitem_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.createhoachargeitem_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-createhoachargeitem"
  
}
module "lambda_updatehoachargeitem" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoachargeitem"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.updatehoachargeitem_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.updatehoachargeitem_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-chargeprocess-updatehoachargeitem"
  
}
module "lambda_createsigningorder" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-createsigningorder"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.createsigningorder_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.createsigningorder_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-notary-createsigningorder"
  
}
module "lambda_getpropertyaddress" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-getpropertyaddress"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.getpropertyaddress_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.getpropertyaddress_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-notary-getpropertyaddress"
  
}
module "lambda_deletesigningorder" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-deletesigningorder"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.deletesigningorder_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.deletesigningorder_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-notary-deletesigningorder"
  
}
module "lambda_getsigningorder" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-getsigningorder"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.getsigningorder_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.getsigningorder_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-notary-getsigningorder"
}
module "lambda_signingorderlist" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-signingorderlist"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.signingorderlist_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.signingorderlist_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-notary-signingorderlist"
  
}
module "lambda_updatesigningorder" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-lambda-mfe-notary-updatesigningorder"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = var.updatesigningorder_lambda_handler_name
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = var.updatesigningorder_lambda_deployment_package_path
  lambda_env_variables           = local.lambda_env_vars
  publish_lambda                 = true
  tags                           = local.tags
  lambda_version                 = 1
  lambda_alias_name              = "${var.project}-${terraform.workspace}-lambda-mfe-notary-updatesigningorder"
  
}

#############################################
#-------------API, API-Lambdas, Dynamo
#############################################
module "dynamodb" {
  source                = "../../modules/dynamodb"
  project               = var.project
  env                   = "${terraform.workspace}"
  region                = data.aws_region.aws-region.name
  dynamodb_table_name   = "${var.project}-${terraform.workspace}-${data.aws_region.aws-region.name}"
  dynamo_billing_mode   = var.dynamo_billing_mode
  dynamo_write_capacity = var.dynamo_write_capacity
  dynamo_read_capacity  = var.dynamo_read_capacity
  hash_key              = var.hash_key
  hash_key_type         = var.hash_key_type
  range_key             = var.range_key
  range_key_type        = var.range_key_type
  tags                  = local.tags
}
module "lambda_layer_01" {
  count                            = var.lambda_layer_01_deployment_pkg_path != "" ? 1 : 0
  source                           = "../../modules/lambda/lambda_layer"
  project                          = var.project
  env                              = "${terraform.workspace}"
  lambda_layer_name                = "${var.project}-${terraform.workspace}-layer"
  lambda_layer_deployment_pkg_path = var.lambda_layer_01_deployment_pkg_path
  lambda_layer_runtime             = var.lambda_function_runtime
}

# module "api_lambda_function_01" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                     = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-CreateBizEntityBuyer"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = var.api_lambda_01_handler_name
#   lambda_function_runtime        = var.lambda_function_runtime
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = var.api_lambda_01_lambda_deployment_package_path
#   lambda_env_variables           = local.lambda_env_vars
#   publish_lambda                 = true
#   lambda_version                 = 1
#   lambda_alias_name              = "${var.project}-${terraform.workspace}-CreateBizEntityBuyer"
#   tags                           = local.tags

# }
# module "api_lambda_function_02" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                     = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-UpsertContact"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = var.api_lambda_02_handler_name
#   lambda_function_runtime        = var.lambda_function_runtime
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = var.api_lambda_02_lambda_deployment_package_path
#   lambda_env_variables           = local.lambda_env_vars
#   tags                           = local.tags
#   publish_lambda                 = true
#   lambda_version                 = 1
#   lambda_alias_name              = "${var.project}-${terraform.workspace}-UpsertContact"
# }
# module "api_lambda_function_03" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                     = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-UpdateBizEntityBuyer"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = var.api_lambda_03_handler_name
#   lambda_function_runtime        = var.lambda_function_runtime
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = var.api_lambda_03_lambda_deployment_package_path
#   lambda_env_variables           = local.lambda_env_vars
#   publish_lambda                 = true
#   tags                           = local.tags
#   lambda_version                 = 1
#   lambda_alias_name              = "${var.project}-${terraform.workspace}-UpdateBizEntityBuyer"
# }
# module "api_lambda_function_04" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                     = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-GetBuyerDetails"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = var.api_lambda_04_handler_name
#   lambda_function_runtime        = var.lambda_function_runtime
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = var.api_lambda_04_lambda_deployment_package_path
#   lambda_env_variables           = local.lambda_env_vars
#   publish_lambda                 = true
#   tags                           = local.tags
#   lambda_version                 = 1
#   lambda_alias_name              = "${var.project}-${terraform.workspace}-GetBuyerDetails"

# }
# module "api_lambda_function_05" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                     = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-GetContacts"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = var.api_lambda_05_handler_name
#   lambda_function_runtime        = var.lambda_function_runtime
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = var.api_lambda_05_lambda_deployment_package_path
#   lambda_env_variables           = local.lambda_env_vars
#   publish_lambda                 = true
#   tags                           = local.tags
#   lambda_version                 = 1
#   lambda_alias_name              = "${var.project}-${terraform.workspace}-GetContacts"
# }
# module "api_lambda_function_06" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                     = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-GetBuyerSummary"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = var.api_lambda_06_handler_name
#   lambda_function_runtime        = var.lambda_function_runtime
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = var.api_lambda_06_lambda_deployment_package_path
#   lambda_env_variables           = local.lambda_env_vars
#   publish_lambda                 = true
#   tags                           = local.tags
#   lambda_version                 = 1
#   lambda_alias_name              = "${var.project}-${terraform.workspace}-GetBuyerSummary"
# }
# module "api_lambda_function_authorizer" {
#   source                         = "../../modules/lambda"
#   project                        = var.project
#   env                            = "${terraform.workspace}"
#   vpc_id                         = var.vpc_id
#   subnet_ids                     = var.lambda_subnet_ids
#   lambda_function_name           = "${var.project}-${terraform.workspace}-Authorizer"
#   #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
#   lambda_handler_name            = var.api_lambda_authorizer_handler_name
#   lambda_function_runtime        = var.lambda_function_runtime
#   lambda_max_memory              = var.lambda_max_memory
#   lambda_timeout                 = var.lambda_timeout
#   lambda_deployment_package_path = var.api_lambda_authorizer_lambda_deployment_package_path
#   lambda_env_variables           = local.lambda_env_vars
#   publish_lambda                 = true
#   tags                           = local.tags
#   lambda_version                 = 1
#   lambda_alias_name              = "${var.project}-${terraform.workspace}-Authorizer"
# }
# module "api_gw" {
#   source                       = "../../modules/api-gw"
#   project                      = var.project
#   env                          = "${terraform.workspace}"
#   account_id                   = data.aws_caller_identity.current.account_id
#   region                       = data.aws_region.aws-region.name
#   authorizer_lambda_invoke_arn = module.api_lambda_function_authorizer.lambda_function_invoke_arn
#   stage_01_name                = var.stage_01_name
#   stage_02_name                = var.stage_02_name
#   api_01                       = var.api_01
#   api_02                       = var.api_02
#   api_03                       = var.api_03
#   api_04                       = var.api_04
#   api_05                       = var.api_05
#   api_06                       = var.api_06
#   api_07                       = var.api_07
#   api_08                       = var.api_08
#   lambda_invoke_arn_01         = module.api_lambda_function_01.lambda_function_invoke_arn
#   lambda_name_01               = module.api_lambda_function_01.lambda_function_name
#   lambda_invoke_arn_02         = module.api_lambda_function_02.lambda_function_invoke_arn
#   lambda_name_02               = module.api_lambda_function_02.lambda_function_name
#   lambda_invoke_arn_03         = module.api_lambda_function_03.lambda_function_invoke_arn
#   lambda_name_03               = module.api_lambda_function_03.lambda_function_name
#   lambda_invoke_arn_04         = module.api_lambda_function_04.lambda_function_invoke_arn
#   lambda_name_04               = module.api_lambda_function_04.lambda_function_name
#   lambda_invoke_arn_05         = module.api_lambda_function_05.lambda_function_invoke_arn
#   lambda_name_05               = module.api_lambda_function_05.lambda_function_name
#   lambda_invoke_arn_06         = module.api_lambda_function_06.lambda_function_invoke_arn
#   lambda_name_06               = module.api_lambda_function_06.lambda_function_name
#   enable_api_xray              = var.enable_api_xray
#   tags                         = local.tags
# }
