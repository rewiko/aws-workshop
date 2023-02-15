output "alb-dns" {
  value = aws_lb.alb.dns_name
}

output "s3-dns" {
  value = aws_s3_bucket.s3.bucket_regional_domain_name
}

