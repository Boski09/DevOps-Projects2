#------------------------------------
#           API
#------------------------------------

resource "aws_api_gateway_rest_api" "api" {
  name =  "${var.project}-${terraform.workspace}-api"
  tags = var.tags
}

#------------------------------------
#           API Authorizer
#------------------------------------
resource "aws_iam_role" "api_auth" {
  name = "${var.project}-${terraform.workspace}-api-auth-invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "api_auth" {
  name   = "${var.project}-${terraform.workspace}-api-auth-invocation"
  role   = aws_iam_role.api_auth.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${var.authorizer_lambda_invoke_arn}"
    }
  ]
}
EOF
}
resource "aws_api_gateway_authorizer" "api_auth" {
  name                             = "${var.project}-${terraform.workspace}-api"
  type                             = "TOKEN"
  rest_api_id                      = aws_api_gateway_rest_api.api.id
  authorizer_uri                   = var.authorizer_lambda_invoke_arn
  authorizer_credentials           = aws_iam_role.api_auth.arn
  authorizer_result_ttl_in_seconds = 0
}

#------------------------------------
#           API 01
#------------------------------------
resource "aws_api_gateway_resource" "api_01" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_01
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/OPTIONS
resource "aws_api_gateway_method" "api_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_01_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_01.id
  http_method          = aws_api_gateway_method.api_01_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_01.id
  http_method         = aws_api_gateway_method.api_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_01.id
  http_method         = aws_api_gateway_method.api_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/POST
resource "aws_api_gateway_method" "api_01_02" {
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api_auth.id
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_01_02" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_01.id
  http_method             = aws_api_gateway_method.api_01_02.http_method
  timeout_milliseconds    = 29000
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn_01
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_01_02" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_01.id
  http_method     = aws_api_gateway_method.api_01_02.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}

#------------------------------------
#           API 02
#------------------------------------
resource "aws_api_gateway_resource" "api_rsc_02" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_02
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}
resource "aws_api_gateway_resource" "api_rsc_02_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_02.id
  path_part   = "{fastFileId}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/OPTIONS
resource "aws_api_gateway_method" "api_mthd_02_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_02_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_02_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_02_01.id
  http_method          = aws_api_gateway_method.api_mthd_02_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_02_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_02_01.id
  http_method         = aws_api_gateway_method.api_mthd_02_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_02_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_02_01.id
  http_method         = aws_api_gateway_method.api_mthd_02_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_02_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}/buyer
resource "aws_api_gateway_resource" "api_rsc_02_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_02_01.id
  path_part   = "buyer"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/buyer/OPTIONS
resource "aws_api_gateway_method" "api_mthd_02_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_02_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_02_01_01" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_02_01_01.id
  http_method             = aws_api_gateway_method.api_mthd_02_01_01.http_method
  timeout_milliseconds    = 29000
  type                    = "MOCK"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_02_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_02_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_02_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_02_02" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_02_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_02_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_02_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}/buyer/{buyerid}
resource "aws_api_gateway_resource" "api_rsc_02_01_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_02_01_01.id
  path_part   = "{buyerid}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/buyer/{buyerid}/OPTIONS
resource "aws_api_gateway_method" "api_mthd_02_01_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_02_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_02_01_01_01" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_02_01_01_01.id
  http_method             = aws_api_gateway_method.api_mthd_02_01_01_01.http_method
  type                    = "MOCK"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_02_01_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_02_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_02_01_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_02_02_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_02_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_02_01_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_02_01_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}/buyer/{buyerid}/PUT
resource "aws_api_gateway_method" "api_mthd_02_01_01_01_02" {
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api_auth.id
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.api_rsc_02_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_02_01_01_01_02" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_02_01_01_01.id
  http_method             = aws_api_gateway_method.api_mthd_02_01_01_01_02.http_method
  type                    = "AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn_02
  timeout_milliseconds    = 29000

  # content_handling        = "CONVERT_TO_TEXT"
  # request_templates       = {
  #   "application/json" = ""
  #   "application/xml"  = "#set($inputRoot = $input.path('$'))\n{ }"
  # }
  # request_parameters      = {
  #   "integration.request.header.X-Authorization" = "'static'"
  #   "integration.request.header.X-Foo"           = "'Bar'"
  # }
}
resource "aws_api_gateway_method_response" "api_mrspc_02_01_01_01_02" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_02_01_01_01.id
  http_method     = aws_api_gateway_method.api_mthd_02_01_01_01_02.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_irspc_02_01_01_01_02" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_02_01_01_01.id
  http_method = aws_api_gateway_method.api_mthd_02_01_01_01_02.http_method
  status_code = aws_api_gateway_method_response.api_mrspc_02_01_01_01_02.status_code
}

#------------------------------------
#           API 03
#------------------------------------

resource "aws_api_gateway_resource" "api_rsc_03" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_03
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#{fastFileId}
resource "aws_api_gateway_resource" "api_rsc_03_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_03.id
  path_part   = "{fastFileId}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#{fastFileId}/OPTIONS
resource "aws_api_gateway_method" "api_mthd_03_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_03_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_03_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_03_01.id
  http_method          = aws_api_gateway_method.api_mthd_03_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_03_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_03_01.id
  http_method         = aws_api_gateway_method.api_mthd_03_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_03_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_03_01.id
  http_method         = aws_api_gateway_method.api_mthd_03_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_03_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#{fastFileId}/buyer
resource "aws_api_gateway_resource" "api_rsc_03_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_03_01.id
  path_part   = "buyer"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#{fastFileId}/buyer/OPTIONS
resource "aws_api_gateway_method" "api_mthd_03_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_03_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_03_01_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_03_01_01.id
  http_method          = aws_api_gateway_method.api_mthd_03_01_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_03_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_03_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_03_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_03_02" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_03_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_03_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_03_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#{fastFileId}/buyer/{buyerid}
resource "aws_api_gateway_resource" "api_rsc_03_01_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_03_01_01.id
  path_part   = "{buyerid}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#{fastFileId}/buyer/{buyerid}/OPTIONS
resource "aws_api_gateway_method" "api_mthd_03_01_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_03_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_03_01_01_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_03_01_01_01.id
  http_method          = aws_api_gateway_method.api_mthd_03_01_01_01.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_03_01_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_03_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_03_01_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_03_02_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_03_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_03_01_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_03_01_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#{fastFileId}/buyer/{buyerid}/GET
resource "aws_api_gateway_method" "api_mthd_03_01_01_01_02" {
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api_auth.id
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api_rsc_03_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_03_01_01_01_02" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_03_01_01_01.id
  http_method             = aws_api_gateway_method.api_mthd_03_01_01_01_02.http_method
  type                    = "AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn_04
  timeout_milliseconds    = 29000

}
resource "aws_api_gateway_method_response" "api_mrspc_03_01_01_01_02" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_03_01_01_01.id
  http_method     = aws_api_gateway_method.api_mthd_03_01_01_01_02.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_irspc_03_01_01_01_02" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_03_01_01_01.id
  http_method = aws_api_gateway_method.api_mthd_03_01_01_01_02.http_method
  status_code = aws_api_gateway_method_response.api_mrspc_03_01_01_01_02.status_code
}

#------------------------------------
#           API 04
#------------------------------------

resource "aws_api_gateway_resource" "api_04" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_04
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}
resource "aws_api_gateway_resource" "api_04_01" {
  parent_id   = aws_api_gateway_resource.api_04.id
  path_part   = "{fastFileId}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#"/{fastFileId}/OPTIONS"
resource "aws_api_gateway_method" "api_04_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_04_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_04_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_04_01.id
  http_method          = aws_api_gateway_method.api_04_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_04_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_04_01.id
  http_method         = aws_api_gateway_method.api_04_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_04_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_04_01.id
  http_method         = aws_api_gateway_method.api_04_01.http_method
  status_code         = aws_api_gateway_method_response.api_04_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}/GET
resource "aws_api_gateway_method" "api_04_01_02" {
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api_auth.id
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api_04_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_04_01_02" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_04_01.id
  http_method             = aws_api_gateway_method.api_04_01_02.http_method
  timeout_milliseconds    = 29000
  type                    = "AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn_06
}
resource "aws_api_gateway_method_response" "api_04_01_02" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_04_01.id
  http_method     = aws_api_gateway_method.api_04_01_02.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_04_01_02" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_04_01.id
  http_method = aws_api_gateway_method.api_04_01_02.http_method
  status_code = aws_api_gateway_method_response.api_04_01_02.status_code
}



#------------------------------------
#           API 05
#------------------------------------
resource "aws_api_gateway_resource" "api_rsc_05" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_05
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}
resource "aws_api_gateway_resource" "api_rsc_05_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_05.id
  path_part   = "{fastFileId}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/OPTIONS
resource "aws_api_gateway_method" "api_mthd_05_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_05_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_05_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_05_01.id
  http_method          = aws_api_gateway_method.api_mthd_05_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_05_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_05_01.id
  http_method         = aws_api_gateway_method.api_mthd_05_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_05_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_05_01.id
  http_method         = aws_api_gateway_method.api_mthd_05_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_05_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}/buyer
resource "aws_api_gateway_resource" "api_rsc_05_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_05_01.id
  path_part   = "buyer"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/buyer/OPTIONS
resource "aws_api_gateway_method" "api_mthd_05_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_05_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_05_01_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_05_01_01.id
  http_method          = aws_api_gateway_method.api_mthd_05_01_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_05_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_05_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_05_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_05_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_05_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_05_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_05_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}/buyer/{buyerid}
resource "aws_api_gateway_resource" "api_rsc_05_01_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_05_01_01.id
  path_part   = "{buyerid}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/buyer/{buyerid}/OPTIONS
resource "aws_api_gateway_method" "api_mthd_05_01_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_05_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_05_01_01_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_05_01_01_01.id
  http_method          = aws_api_gateway_method.api_mthd_05_01_01_01.http_method
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  type                 = "MOCK"
  timeout_milliseconds = 29000
}
resource "aws_api_gateway_method_response" "api_mrspc_05_01_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_05_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_05_01_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_05_02_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_05_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_05_01_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_05_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}/buyer/{buyerid}/GET
resource "aws_api_gateway_method" "api_mthd_05_01_01_01_02" {
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api_auth.id
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api_rsc_05_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_05_01_01_01_02" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_05_01_01_01.id
  http_method             = aws_api_gateway_method.api_mthd_05_01_01_01_02.http_method
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn_05
  timeout_milliseconds    = 29000
}
resource "aws_api_gateway_method_response" "api_mrspc_05_01_01_01_02" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_05_01_01_01.id
  http_method     = aws_api_gateway_method.api_mthd_05_01_01_01_02.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_irspc_05_01_01_01_02" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_05_01_01_01.id
  http_method = aws_api_gateway_method.api_mthd_05_01_01_01_02.http_method
  status_code = aws_api_gateway_method_response.api_mrspc_05_01_01_01_02.status_code
}

#------------------------------------
#           API 06
#------------------------------------
resource "aws_api_gateway_resource" "api_06" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_06
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/OPTIONS
resource "aws_api_gateway_method" "api_06" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_06.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_06" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_06.id
  http_method          = aws_api_gateway_method.api_06.http_method
  timeout_milliseconds = 29000
  type                    = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_06" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_06.id
  http_method         = aws_api_gateway_method.api_06.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_06" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_06.id
  http_method         = aws_api_gateway_method.api_06.http_method
  status_code         = aws_api_gateway_method_response.api_06.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{buyerid}
resource "aws_api_gateway_resource" "api_06_01" {
  parent_id   = aws_api_gateway_resource.api_06.id
  path_part   = "{buyerid}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{buyerid}/OPTIONS
resource "aws_api_gateway_method" "api_06_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_06_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_06_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_06_01.id
  http_method          = aws_api_gateway_method.api_06_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_06_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_06_01.id
  http_method         = aws_api_gateway_method.api_06_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_06_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_06_01.id
  http_method         = aws_api_gateway_method.api_06_01.http_method
  status_code         = aws_api_gateway_method_response.api_06_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{buyerid}/DELETE
resource "aws_api_gateway_method" "api_mthd_06_01_02" {
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api_auth.id
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.api_06_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_06_01_02" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_06_01.id
  http_method          = aws_api_gateway_method.api_mthd_06_01_02.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_06_01_02" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_06_01.id
  http_method     = aws_api_gateway_method.api_mthd_06_01_02.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_irspc_06_01_02" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_06_01.id
  http_method = aws_api_gateway_method.api_mthd_06_01_02.http_method
  status_code = aws_api_gateway_method_response.api_mrspc_06_01_02.status_code
}


#------------------------------------
#           API 07
#------------------------------------
resource "aws_api_gateway_resource" "api_07" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_07
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/OPTIONS
resource "aws_api_gateway_method" "api_07_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_07.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_07_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_07.id
  http_method          = aws_api_gateway_method.api_07_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_07_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_07.id
  http_method         = aws_api_gateway_method.api_07_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_07_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_07.id
  http_method         = aws_api_gateway_method.api_07_01.http_method
  status_code         = aws_api_gateway_method_response.api_07_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/PUT
resource "aws_api_gateway_method" "api_07_02" {
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api_auth.id
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.api_07.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_07_02" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_07.id
  http_method             = aws_api_gateway_method.api_07_02.http_method
  timeout_milliseconds    = 29000
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn_03
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_method_response" "api_07_02" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_07.id
  http_method     = aws_api_gateway_method.api_07_02.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}


#------------------------------------
#           API 08
#------------------------------------

resource "aws_api_gateway_resource" "api_rsc_08" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_08
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/OPTIONS
resource "aws_api_gateway_method" "api_08" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_08.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_08" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_08.id
  http_method          = aws_api_gateway_method.api_08.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_08" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08.id
  http_method         = aws_api_gateway_method.api_08.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_08" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08.id
  http_method         = aws_api_gateway_method.api_08.http_method
  status_code         = aws_api_gateway_method_response.api_08.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}
resource "aws_api_gateway_resource" "api_rsc_08_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_08.id
  path_part   = "{fastFileId}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/OPTIONS
resource "aws_api_gateway_method" "api_mthd_08_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_08_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_08_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_08_01.id
  http_method          = aws_api_gateway_method.api_mthd_08_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_08_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_08_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_08_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}/buyer
resource "aws_api_gateway_resource" "api_rsc_08_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_08_01.id
  path_part   = "buyer"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/buyer/OPTIONS
resource "aws_api_gateway_method" "api_mthd_08_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_08_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_08_01_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_08_01_01.id
  http_method          = aws_api_gateway_method.api_mthd_08_01_01.http_method
  timeout_milliseconds = 29000
  type                 = "MOCK" 
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_08_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_08_02" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_08_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}

#/{fastFileId}/buyer{buyerid}
resource "aws_api_gateway_resource" "api_rsc_08_01_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_08_01_01.id
  path_part   = "{buyerid}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/buyer/{buyerid}/OPTIONS
resource "aws_api_gateway_method" "api_mthd_08_01_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_08_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_08_01_01_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_08_01_01_01.id
  http_method          = aws_api_gateway_method.api_mthd_08_01_01_01.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_08_01_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_08_02_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_08_01_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}

#/{fastFileId}/buyer/{buyerid}/contact
resource "aws_api_gateway_resource" "api_rsc_08_01_01_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_08_01_01_01.id
  path_part   = "contact"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/buyer/{buyerid}/contact/OPTIONS
resource "aws_api_gateway_method" "api_mthd_08_01_01_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_08_01_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_08_01_01_01_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_08_01_01_01_01.id
  http_method          = aws_api_gateway_method.api_mthd_08_01_01_01_01.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_08_01_01_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01_01_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_08_01_01_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01_01_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_08_01_01_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}
#/{fastFileId}/buyer/{buyerid}/contact/{contactId}
resource "aws_api_gateway_resource" "api_rsc_08_01_01_01_01_01" {
  parent_id   = aws_api_gateway_resource.api_rsc_08_01_01_01_01.id
  path_part   = "{contactId}"
  rest_api_id = aws_api_gateway_rest_api.api.id
}
#/{fastFileId}/buyer/{buyerid}/contact{contactId}/OPTIONS
resource "aws_api_gateway_method" "api_mthd_08_01_01_01_01_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_08_01_01_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_08_01_01_01_01_01" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.api_rsc_08_01_01_01_01_01.id
  http_method          = aws_api_gateway_method.api_mthd_08_01_01_01_01_01.http_method
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mrspc_08_01_01_01_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01_01_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01_01_01_01_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_irspc_08_01_01_01_01_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_08_01_01_01_01_01.id
  http_method         = aws_api_gateway_method.api_mthd_08_01_01_01_01_01.http_method
  status_code         = aws_api_gateway_method_response.api_mrspc_08_01_01_01_01_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}

#/{fastFileId}/buyer/{buyerid}/contact/{contactid}/Put
resource "aws_api_gateway_method" "api_mthd_08_01_01_01_01_01_01" {
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api_auth.id
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.api_rsc_08_01_01_01_01_01.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_int_08_01_01_01_01_01_01" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_08_01_01_01_01_01.id
  http_method             = aws_api_gateway_method.api_mthd_08_01_01_01_01_01_01.http_method
  type                    = "AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn_02
  timeout_milliseconds    = 29000

}
resource "aws_api_gateway_method_response" "api_mrspc_08_01_01_01_01_01_01" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_08_01_01_01_01_01.id
  http_method     = aws_api_gateway_method.api_mthd_08_01_01_01_01_01_01.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_irspc_08_01_01_01_01_01_01" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_08_01_01_01_01_01.id
  http_method = aws_api_gateway_method.api_mthd_08_01_01_01_01_01_01.http_method
  status_code = aws_api_gateway_method_response.api_mrspc_08_01_01_01_01_01_01.status_code
}




#------------------------------------
#           API Deployments
#------------------------------------
resource "aws_api_gateway_deployment" "api_deployment_01" {
  depends_on        = [aws_api_gateway_rest_api.api]
  rest_api_id       = aws_api_gateway_rest_api.api.id
  description       = "Deployed at ${timestamp()}"
  stage_name        = var.stage_01_name
  stage_description = "Deployed at ${timestamp()}"
}
resource "aws_api_gateway_deployment" "api_deployment_02" {
  depends_on        = [aws_api_gateway_rest_api.api]
  rest_api_id       = aws_api_gateway_rest_api.api.id
  description       = "Deployed at ${timestamp()}"
  stage_name        = var.stage_02_name
  stage_description = "Deployed at ${timestamp()}"
}
# resource "aws_api_gateway_stage" "api_stage_01" {
#   deployment_id = aws_api_gateway_deployment.api_deployment_01.id
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   stage_name    = var.stage_01_name
#   description   = "Deployed at ${timestamp()}"
#   xray_tracing_enabled = var.enable_api_xray
# }
# resource "aws_api_gateway_stage" "api_stage_02" {
#   deployment_id = aws_api_gateway_deployment.api_deployment_02.id
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   stage_name    = var.stage_02_name
#   description   = "Deployed at ${timestamp()}"
#   xray_tracing_enabled = var.enable_api_xray
# }


#------------------------------------
#          Lambda permissions
#------------------------------------

resource "aws_lambda_permission" "api_01_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_01 
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_01_02.http_method}${aws_api_gateway_resource.api_01.path}"
}
resource "aws_lambda_permission" "api_02_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway2"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_02 
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_mthd_02_01_01_01_02.http_method}${aws_api_gateway_resource.api_rsc_02_01_01_01.path}"
}
resource "aws_lambda_permission" "api_03_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway3"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_04
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_mthd_03_01_01_01_02.http_method}${aws_api_gateway_resource.api_rsc_03_01_01_01.path}"
}
resource "aws_lambda_permission" "api_04_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway4"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_06
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_04_01.http_method}${aws_api_gateway_resource.api_04_01.path}"
}
resource "aws_lambda_permission" "api_05_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway5"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_05
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_mthd_05_01_01_01_02.http_method}${aws_api_gateway_resource.api_rsc_05_01_01_01.path}"
}
resource "aws_lambda_permission" "api_07_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway7"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_03
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_07_02.http_method}${aws_api_gateway_resource.api_07.path}"
}
resource "aws_lambda_permission" "api_08_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway8"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name_02
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_mthd_08_01_01_01_01_01_01.http_method}${aws_api_gateway_resource.api_rsc_08_01_01_01_01_01.path}"
}