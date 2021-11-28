provider "aws" {
  region = "eu-central-1"
}

//s3 bucket for static web hosting
resource "aws_s3_bucket" "static" {
  bucket = "pedkopp92iasd.com"
  acl    = "public-read"

  provisioner "local-exec" {
    command = "aws s3 sync static/ s3://pedkopp92iasd.com --acl public-read --delete"
  }

  website {
    index_document = "index.html"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "delete-old-versions"
    enabled = true
    prefix  = "static"
    expiration {
      days = 365
    }
  }

}
