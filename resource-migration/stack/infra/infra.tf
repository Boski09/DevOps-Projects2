data "aws_region" "aws-region" {}
data "aws_caller_identity" "current" {}

locals {
  tags = {
    "Application Service Number"  = "APP0005852"
    "Business Application Number" = "APM0001866"
    "Application Name"            = "Ignite"
    "Environment name"            = "${terraform.workspace}"
  }
  lambda_env_vars = {}
  
}

module "dynamodb" {
  source                = "../../modules/dynamodb"
  project               = var.project
  env                   = "${terraform.workspace}"
  region                = data.aws_region.aws-region.name
  dynamodb_table_name   = "${var.project}-${var.env}-${data.aws_region.aws-region.name}"
  dynamo_billing_mode   = "PROVISIONED"
  dynamo_write_capacity = 10
  dynamo_read_capacity  = 5
  hash_key              = "id"
  hash_key_type         = "S"
  range_key             = "name"
  range_key_type        = "N"
  tags                  = local.tags
}
module "lambda_function_01" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-CreateBizEntityBuyer"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = "dotnetcore3.1"
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  tags                           = local.tags
}
module "lambda_function_02" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-UpsertContact"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = "dotnetcore3.1"
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  tags                           = local.tags
}
module "lambda_function_03" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-UpdateBizEntityBuyer"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = "dotnetcore3.1"
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  tags                           = local.tags
}
module "lambda_function_04" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-GetBuyerDetails"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = "dotnetcore3.1"
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  tags                           = local.tags
}
module "lambda_function_05" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-GetContacts"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = "dotnetcore3.1"
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  tags                           = local.tags
}
module "lambda_function_06" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-GetBuyerSummary"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = "dotnetcore3.1"
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  tags                           = local.tags
}
module "lambda_function_authorizer" {
  source                         = "../../modules/lambda"
  project                        = var.project
  env                            = "${terraform.workspace}"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "${var.project}-${terraform.workspace}-Authorizer"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = "dotnetcore3.1"
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
  lambda_env_variables           = local.lambda_env_vars
  tags                           = local.tags
}

module "api_gw" {
  source                       = "../../modules/api-gw"
  project                      = var.project
  env                          = "${terraform.workspace}"
  account_id                   = data.aws_caller_identity.current.account_id
  region                       = data.aws_region.aws-region.name
  authorizer_lambda_invoke_arn = module.lambda_function_authorizer.lambda_function_invoke_arn
  stage_01_name                = "dev"
  stage_02_name                = "qatest"
  api_01                       = "createbizentitybuyer"
  api_02                       = "createcontact"
  api_03                       = "getbuyerdetails"
  api_04                       = "getbuyersummary"
  api_05                       = "getcontacts"
  api_06                       = "removebizidentitybuyer"
  api_07                       = "updatebizidentitybuyer"
  api_08                       = "updatecontacts"
  lambda_invoke_arn_01         = module.lambda_function_01.lambda_function_invoke_arn
  lambda_name_01               = module.lambda_function_01.lambda_function_name
  lambda_invoke_arn_02         = module.lambda_function_02.lambda_function_invoke_arn
  lambda_name_02               = module.lambda_function_02.lambda_function_name
  lambda_invoke_arn_03         = module.lambda_function_03.lambda_function_invoke_arn
  lambda_name_03               = module.lambda_function_03.lambda_function_name
  lambda_invoke_arn_04         = module.lambda_function_04.lambda_function_invoke_arn
  lambda_name_04               = module.lambda_function_04.lambda_function_name
  lambda_invoke_arn_05         = module.lambda_function_05.lambda_function_invoke_arn
  lambda_name_05               = module.lambda_function_05.lambda_function_name
  lambda_invoke_arn_06         = module.lambda_function_06.lambda_function_invoke_arn
  lambda_name_06               = module.lambda_function_06.lambda_function_name
  enable_api_xray              = true
  tags                         = local.tags
}