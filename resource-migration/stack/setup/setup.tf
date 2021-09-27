data "aws_region" "aws-region" {}
data "aws_caller_identity" "current" {}
locals {
    account_id = data.aws_caller_identity.current.account_id
    aws_region = data.aws_region.aws-region.name
    tags = {
      "Application Service Number" = "1223"
      "Business Application Number" = "678"
      "Application Name" = "Victor"
      "Environment name" = "cert"
    }
}
resource "aws_s3_bucket" "tf_state_s3_bucket" {
  bucket = "${var.project}-${var.env}-tf-backend-${local.aws_region}-${local.account_id}"
  acl    = "private"

  versioning {
    enabled = var.s3_versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     =  "AES256" #"aws:kms" |
      }
    }
  }
  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket = aws_s3_bucket.tf_state_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true 
  restrict_public_buckets = true 
}

resource "aws_dynamodb_table" "tf_lock_dynamo_table" {
  name         = "${var.project}-${var.env}-tf-lock-${local.aws_region}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = local.tags
}