# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  count = var.domain_name != "" ? 1 : 0
  name  = var.domain_name
  
  tags = {
    Name = "${var.project_name}-zone"
  }
}

# Route53 Health Checks
resource "aws_route53_health_check" "primary" {
  count                           = var.domain_name != "" ? 1 : 0
  fqdn                           = var.primary_alb_dns
  port                           = 80
  type                           = "HTTP"
  resource_path                  = "/health"
  failure_threshold              = 3
  request_interval               = 30
  cloudwatch_alarm_region        = "us-east-1"
  cloudwatch_alarm_name          = "${var.project_name}-primary-health"
  insufficient_data_health_status = "Failure"
  
  tags = {
    Name = "${var.project_name}-primary-health"
  }
}

resource "aws_route53_health_check" "secondary" {
  count                           = var.domain_name != "" ? 1 : 0
  fqdn                           = var.secondary_alb_dns
  port                           = 80
  type                           = "HTTP"
  resource_path                  = "/health"
  failure_threshold              = 3
  request_interval               = 30
  cloudwatch_alarm_region        = "us-east-2"
  cloudwatch_alarm_name          = "${var.project_name}-secondary-health"
  insufficient_data_health_status = "Failure"
  
  tags = {
    Name = "${var.project_name}-secondary-health"
  }
}

resource "aws_route53_health_check" "tertiary" {
  count                           = var.domain_name != "" ? 1 : 0
  fqdn                           = var.tertiary_alb_dns
  port                           = 80
  type                           = "HTTP"
  resource_path                  = "/health"
  failure_threshold              = 3
  request_interval               = 30
  cloudwatch_alarm_region        = "us-west-2"
  cloudwatch_alarm_name          = "${var.project_name}-tertiary-health"
  insufficient_data_health_status = "Failure"
  
  tags = {
    Name = "${var.project_name}-tertiary-health"
  }
}

# S3 Buckets for cross-region backup
resource "aws_s3_bucket" "backup_primary" {
  bucket = "${var.project_name}-backup-primary-${random_string.bucket_suffix.result}"
  
  tags = {
    Name = "${var.project_name}-backup-primary"
  }
}

resource "aws_s3_bucket" "backup_secondary" {
  bucket = "${var.project_name}-backup-secondary-${random_string.bucket_suffix.result}"
  
  tags = {
    Name = "${var.project_name}-backup-secondary"
  }
}

resource "aws_s3_bucket" "backup_tertiary" {
  bucket = "${var.project_name}-backup-tertiary-${random_string.bucket_suffix.result}"
  
  tags = {
    Name = "${var.project_name}-backup-tertiary"
  }
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "backup_primary" {
  bucket = aws_s3_bucket.backup_primary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "backup_secondary" {
  bucket = aws_s3_bucket.backup_secondary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "backup_tertiary" {
  bucket = aws_s3_bucket.backup_tertiary.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "backup_primary" {
  bucket = aws_s3_bucket.backup_primary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup_secondary" {
  bucket = aws_s3_bucket.backup_secondary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup_tertiary" {
  bucket = aws_s3_bucket.backup_tertiary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Random string for unique bucket names
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# CloudFront Distribution for Global CDN
resource "aws_cloudfront_distribution" "main" {
  count = var.domain_name != "" ? 1 : 0
  
  origin {
    domain_name = var.primary_alb_dns
    origin_id   = "${var.project_name}-primary"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  
  aliases = var.domain_name != "" ? [var.domain_name] : []
  
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.project_name}-primary"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
  tags = {
    Name = "${var.project_name}-cloudfront"
  }
}
