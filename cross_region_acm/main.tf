locals {
  certs_bucket  = data.terraform_remote_state.certs_bucket.outputs.name
  path_prefix   = "tls"
}

variable "cert" {
  type        = map(any)
  description = "cert file names"

  default = {  # make sure these match the filenames uploaded
    "key"   = "cert.key"
    "crt"   = "cert.crt"
    "chain" = "ca.crt"
  }
}

# Sync TLS folder from S3 - no other way to do this I could find!
resource "null_resource" "get_cert_objects" {
  provisioner "local-exec" {
    command = "aws --region ${var.aws_region} s3 sync s3://${local.certs_bucket}/${local.path_prefix} ./${local.path_prefix}"
  }
}

resource "aws_acm_certificate" "cert" {
  certificate_body  = data.local_file.crt.content
  private_key       = data.local_file.key.content
  certificate_chain = data.local_file.chain.content

  tags = merge(
    { Name = "TLS Cert Import Test - ${var.aws_region}" }
  )
}

resource "aws_acm_certificate" "cert_us" {
  # for e.g. CloudFront
  provider  = aws.useast1

  certificate_body  = data.local_file.crt.content
  private_key       = data.local_file.key.content
  certificate_chain = data.local_file.chain.content

  tags = merge(
    { Name = "TLS Cert Import Test - US" }
  )
}

data "local_file" "crt" {
  depends_on  = [ null_resource.get_cert_objects ]
  filename    = "${path.module}/${local.path_prefix}/${var.cert.crt}"
}

data "local_file" "key" {
  depends_on  = [ null_resource.get_cert_objects ]
  filename    = "${path.module}/${local.path_prefix}/${var.cert.key}"
}

data "local_file" "chain" {
  depends_on  = [ null_resource.get_cert_objects ]
  filename    = "${path.module}/${local.path_prefix}/${var.cert.chain}"
}
