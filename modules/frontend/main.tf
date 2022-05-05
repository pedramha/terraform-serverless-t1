provider "aws" {
    region      = "eu-west-1"
}

locals {
  bucket_name = "s3-bucket-pedram-company-website"
}

# module "s3-bucket" {
#   source  = "app.terraform.io/pedram-company/s3-bucket/aws"
#   tags = {
#     Owner = "pedramhamidehkhan"
#   }
#   acl    = "public-read"
#     provisioner "local-exec" {
#     command = "aws s3 sync static/ s3:/${bucket_name}.com --acl public-read --delete"
#   }
# website {
#   index_document = "index.html"
# }
# }

resource "aws_s3_bucket" "static" {
  bucket = "${local.bucket_name}"
  acl    = "public-read"
  
  provisioner "local-exec" {
    command = "aws s3 sync static/ s3://${local.bucket_name}.com --acl public-read --delete"
  }

website {
  index_document = "index.html"
}

}