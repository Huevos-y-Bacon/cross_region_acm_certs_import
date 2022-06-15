locals {
  path_prefix = "tls"
}

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "certs" {
  bucket = "certs-${random_string.random.id}"

  tags = {
    Name = "certs-${random_string.random.id}"
  }
}

resource "aws_s3_bucket_acl" "certs" {
  bucket = aws_s3_bucket.certs.id
  acl    = "private"
}

resource "aws_s3_object" "objects" {
  for_each = fileset("${local.path_prefix}/", "*.{key,pem,crt}")

  bucket = aws_s3_bucket.certs.id
  key    = "${local.path_prefix}/${each.value}"
  source = "${local.path_prefix}/${each.value}"
  etag   = filemd5("${local.path_prefix}/${each.value}")
}
