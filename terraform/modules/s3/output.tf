output "s3_bucket" {
    value = aws_s3_bucket.s3_bucket.id
}
output "s3_logs_bucket" {
    value = aws_s3_bucket.s3_logs_bucket.id
}
output "bucket_domain_name" {
    value = aws_s3_bucket.s3_bucket.bucket_domain_name
}