output "name" {
  description = "The name of the certs bucket"
  value       = aws_s3_bucket.certs.id
}
