output "tf_state_s3_bucket" {
    value = aws_s3_bucket.tf_state_s3_bucket.id
}
output "tf_lock_dynamo_table" {
    value = aws_dynamodb_table.tf_lock_dynamo_table.arn
}