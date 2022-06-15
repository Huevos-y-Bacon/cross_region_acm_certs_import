# Simple example to deploy resource across multiple regions in a single TF template
# - see https://stackoverflow.com/a/68965032

# resource "random_string" "random" {
#   length  = 16
#   special = false
#   upper   = false
# }

# resource "aws_s3_bucket" "eu_west_1" {
#   bucket = "euwest1-${random_string.random.id}"
# }

# resource "aws_s3_bucket" "us_east_1" {
#   bucket    = "useast1-${random_string.random.id}"
#   provider  = aws.useast1
# }
