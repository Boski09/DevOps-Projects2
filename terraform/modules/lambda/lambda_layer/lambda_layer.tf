
resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = var.lambda_layer_name
  filename            = var.lambda_layer_deployment_pkg_path
  compatible_runtimes = [var.lambda_layer_runtime]
  description         = var.lambda_layer_name
  source_code_hash    = filebase64sha256(var.lambda_layer_deployment_pkg_path)
}