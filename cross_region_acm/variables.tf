data "terraform_remote_state" "certs_bucket" {
  backend = "local"

  config = {
    path = "${path.module}/../certs_bucket/terraform.tfstate"
  }
}

variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "eu-west-1"
}
