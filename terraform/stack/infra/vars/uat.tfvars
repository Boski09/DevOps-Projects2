project = "ddms"

#### S3 bucket var-values ####
s3_versioning = true

#### Lambda function var-values ####
vpc_id                  = "vpc-d53b0ead"
lambda_subnet_ids       = ["subnet-0b76e756", "subnet-a03494ea"]
lambda_max_memory       = "800"
lambda_timeout          =  "3"
lambda_function_runtime = "dotnetcore3.1"

getlookupdata_lambda_handler_name                     = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
getlookupdata_lambda_deployment_package_path          = "../../modules/lambda/lambda_function.zip"
getchargetypes_lambda_handler_name                    = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
getchargetypes_lambda_deployment_package_path         = "../../modules/lambda/lambda_function.zip"
deletehoachargeitem_lambda_handler_name               = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
deletehoachargeitem_lambda_deployment_package_path    = "../../modules/lambda/lambda_function.zip"
gethoacharge_lambda_handler_name                      = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
gethoacharge_lambda_deployment_package_path           = "../../modules/lambda/lambda_function.zip"
getindividualhoacharge_lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
getindividualhoacharge_lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"
updatehoadues_lambda_handler_name                     = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
updatehoadues_lambda_deployment_package_path          = "../../modules/lambda/lambda_function.zip"
updatehoaentity_lambda_handler_name                   = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
updatehoaentity_lambda_deployment_package_path        = "../../modules/lambda/lambda_function.zip"
updatehoaproration_lambda_handler_name                = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
updatehoaproration_lambda_deployment_package_path     = "../../modules/lambda/lambda_function.zip"
createhoacharge_lambda_handler_name                   = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
createhoacharge_lambda_deployment_package_path        = "../../modules/lambda/lambda_function.zip"
createhoachargeitem_lambda_handler_name               = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
createhoachargeitem_lambda_deployment_package_path    = "../../modules/lambda/lambda_function.zip"
updatehoachargeitem_lambda_handler_name               = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
updatehoachargeitem_lambda_deployment_package_path    = "../../modules/lambda/lambda_function.zip"
createsigningorder_lambda_handler_name                = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
createsigningorder_lambda_deployment_package_path     = "../../modules/lambda/lambda_function.zip"
getpropertyaddress_lambda_handler_name                = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
getpropertyaddress_lambda_deployment_package_path     = "../../modules/lambda/lambda_function.zip"
deletesigningorder_lambda_handler_name                = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
deletesigningorder_lambda_deployment_package_path     = "../../modules/lambda/lambda_function.zip"
getsigningorder_lambda_handler_name                   = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
getsigningorder_lambda_deployment_package_path        = "../../modules/lambda/lambda_function.zip"
signingorderlist_lambda_handler_name                  = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
signingorderlist_lambda_deployment_package_path       = "../../modules/lambda/lambda_function.zip"
updatesigningorder_lambda_handler_name                = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
updatesigningorder_lambda_deployment_package_path     = "../../modules/lambda/lambda_function.zip"

#### Cloud front var-values ####
is_ipv6_enabled                = true
default_root_object            = "index.html"
s3_bucket_log_prefix           = "cf-logs"
cookies_in_logs                = true
cf_alias                       = ""
forward_query_string_to_origin = false
forward_header_to_origin       = []
cokkies_to_forward             = "all"
whitelisted_cookies_to_forward = [""]
viewer_protocol_policy         = "redirect-to-https"
min_ttl                        = 0
default_ttl                    = 3600
max_ttl                        = 86400
price_class                    = "PriceClass_200"
geo_restriction_type           = "none"
geo_locations                  = [""]
acm_certificate_arn            = ""

###     API var-values     ####
api_lambda_01_handler_name                           = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
api_lambda_01_lambda_deployment_package_path         = "../../modules/lambda/lambda_function.zip"
api_lambda_02_handler_name                           = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
api_lambda_02_lambda_deployment_package_path         = "../../modules/lambda/lambda_function.zip"
api_lambda_03_handler_name                           = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
api_lambda_03_lambda_deployment_package_path         = "../../modules/lambda/lambda_function.zip"
api_lambda_04_handler_name                           = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
api_lambda_04_lambda_deployment_package_path         = "../../modules/lambda/lambda_function.zip"
api_lambda_05_handler_name                           = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
api_lambda_05_lambda_deployment_package_path         = "../../modules/lambda/lambda_function.zip"
api_lambda_06_handler_name                           = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
api_lambda_06_lambda_deployment_package_path         = "../../modules/lambda/lambda_function.zip"
api_lambda_authorizer_handler_name                   = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
api_lambda_authorizer_lambda_deployment_package_path = "../../modules/lambda/lambda_function.zip"

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
enable_api_xray              = false

###     dynamoDB var-values     ####
dynamo_billing_mode   = "PROVISIONED"
dynamo_write_capacity = 10
dynamo_read_capacity  = 5
hash_key              = "id"
hash_key_type         = "S"
range_key             = "name"
range_key_type        = "N"