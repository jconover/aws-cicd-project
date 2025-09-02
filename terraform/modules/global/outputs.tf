output "hosted_zone_id" {
  description = "The hosted zone ID"
  value       = var.domain_name != "" ? aws_route53_zone.main[0].zone_id : null
}

output "hosted_zone_name_servers" {
  description = "The name servers for the hosted zone"
  value       = var.domain_name != "" ? aws_route53_zone.main[0].name_servers : null
}

output "cloudfront_distribution_id" {
  description = "The identifier for the CloudFront distribution"
  value       = var.domain_name != "" ? aws_cloudfront_distribution.main[0].id : null
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name corresponding to the CloudFront distribution"
  value       = var.domain_name != "" ? aws_cloudfront_distribution.main[0].domain_name : null
}

output "backup_bucket_primary" {
  description = "Name of the primary backup S3 bucket"
  value       = aws_s3_bucket.backup_primary.id
}

output "backup_bucket_secondary" {
  description = "Name of the secondary backup S3 bucket"
  value       = aws_s3_bucket.backup_secondary.id
}

output "backup_bucket_tertiary" {
  description = "Name of the tertiary backup S3 bucket"
  value       = aws_s3_bucket.backup_tertiary.id
}

output "health_check_primary_id" {
  description = "The health check ID for primary region"
  value       = var.domain_name != "" ? aws_route53_health_check.primary[0].id : null
}

output "health_check_secondary_id" {
  description = "The health check ID for secondary region"
  value       = var.domain_name != "" ? aws_route53_health_check.secondary[0].id : null
}

output "health_check_tertiary_id" {
  description = "The health check ID for tertiary region"
  value       = var.domain_name != "" ? aws_route53_health_check.tertiary[0].id : null
}
