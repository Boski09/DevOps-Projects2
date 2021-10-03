output "api_deployment_01" {
    value = aws_api_gateway_deployment.api_deployment_01.invoke_url
}
output "api_deployment_02" {
    value = aws_api_gateway_deployment.api_deployment_02.invoke_url
}