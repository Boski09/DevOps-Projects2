data "aws_region" "aws-region" {}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = var.s3_versioning
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        /* kms_master_key_id = aws_kms_key.mykey.arn */
        sse_algorithm     =  "AES256" #"aws:kms" |
      }
    }
  }
  website {
    index_document = var.website_index_page
    error_document = var.website_error_page
  }


  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true 
  restrict_public_buckets = true 
}

resource "aws_s3_bucket" "s3_logs_bucket" {
  bucket = var.s3_logs_bucket_name
  acl    = "private"

  versioning {
    enabled = var.s3_versioning
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     =  "AES256"
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "s3_logs_bucket_access_block" {
  bucket = aws_s3_bucket.s3_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true 
  restrict_public_buckets = true 
}