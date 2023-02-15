
variable "bucket_name" {
  default = "workshop-bucket-s3"
}

variable "acl_value" {
  default = "private"
  #   default = "public-read"
}

resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name

  tags = {
    Name        = "workshop bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3.id
  acl    = var.acl_value
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#static-website-hosting
# # Static Website Hosting

# ```
# resource "aws_s3_bucket" "b" {
#   bucket = "s3-website-test.hashicorp.com"
#   acl    = "public-read"
#   policy = file("policy.json")

#   website {
#     index_document = "index.html"
#     error_document = "error.html"

#     routing_rules = <<EOF
# [{
#     "Condition": {
#         "KeyPrefixEquals": "docs/"
#     },
#     "Redirect": {
#         "ReplaceKeyPrefixWith": "documents/"
#     }
# }]
# EOF
#   }
# }
# ```
