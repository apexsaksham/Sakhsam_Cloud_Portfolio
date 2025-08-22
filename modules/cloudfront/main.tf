# -------------------------------
# Create an Origin Access Identity (OAI)
# This allows CloudFront to securely access S3 content
# -------------------------------
resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "OAI for CloudFront to access S3 bucket"
}

# -------------------------------
# Create CloudFront Distribution
# -------------------------------
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  default_root_object = "index.html"  # File served when user hits root domain

  # -------------------------------
  # Origin block (MUST be singular, not origins)
  # -------------------------------
  origin {
    domain_name = var.s3_bucket_regional_domain_name  # Comes from S3 module
    origin_id   = "s3-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  # -------------------------------
  # Cache behavior
  # -------------------------------
  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"  # Forces HTTPS
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # -------------------------------
  # Where CloudFront serves from (cost vs. performance tradeoff)
  # -------------------------------
  price_class = "PriceClass_100" # Cheapest (US, Canada, Europe only)

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # -------------------------------
  # SSL/TLS settings
  # Using default CloudFront cert (*.cloudfront.net)
  # -------------------------------
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # -------------------------------
  # Optional: aliases (for custom domains)
  # If not using your own domain, just leave empty []
  # -------------------------------
  aliases = []
}
