locals {
  s3_origin_id = "${var.project}-${var.env}-origin-01"
}



resource "aws_cloudfront_origin_access_identity" "cf_origin_id" {
  comment = "Some comment"
}


resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = "${var.s3_domain_bucket_name}.s3.amazonaws.com"
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_origin_id.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = "${var.project}-${var.env}-cloudfront-domain"
  default_root_object =  var.default_root_object

  logging_config {
    include_cookies = var.cookies_in_logs
    bucket          = "${var.logging_bucket}.s3.amazonaws.com"
    prefix          = var.s3_bucket_log_prefix
  }

  aliases = var.cf_alias != "" ?  [var.cf_alias] : null

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = var.forward_query_string_to_origin
      headers      = length(var.forward_header_to_origin) != 0 ? var.forward_header_to_origin : null

      cookies {
        forward           = var.cokkies_to_forward
        whitelisted_names = var.cokkies_to_forward == "whitelist" ? var.whitelisted_cookies_to_forward : null
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl 
    max_ttl                = var.max_ttl 
  }



  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_type != "none" ? var.geo_locations : null
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn != "" ? var.acm_certificate_arn : null
    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : null
  }

  tags = var.tags
}

data "aws_iam_policy_document" "cf_bucket_policy" {
    statement {
        sid = "cf-bucket-policy-01"
        actions = [
            "s3:GetObject",
            "s3:GetObjectVersion"
        ]
        resources = [
            "arn:aws:s3:::${var.s3_domain_bucket_name}",
            "arn:aws:s3:::${var.s3_domain_bucket_name}/*",
        ]
        principals {
            type        = "AWS"
            identifiers = [aws_cloudfront_origin_access_identity.cf_origin_id.iam_arn]
        }
  }
}
resource "aws_s3_bucket_policy" "cloudfront_s3_bucket_policy" {
   depends_on  = [aws_cloudfront_origin_access_identity.cf_origin_id]
    bucket = var.s3_domain_bucket_name
    policy = data.aws_iam_policy_document.cf_bucket_policy.json

}