output "dynamodb" {
    value = aws_dynamodb_table.dynamo_table.arn
}