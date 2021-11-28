provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "static" {
  bucket = "pedkopp92iasd.com"
  acl    = "public-read"

  provisioner "local-exec" {
    command = "aws s3 sync static/ s3://pedkopp92iasd.com --acl public-read --delete"
  }

  website {
    index_document = "index.html"
  }

#   versioning {
#     enabled = true
#   }


}
