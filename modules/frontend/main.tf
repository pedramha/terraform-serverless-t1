provider "aws" {
  
}

locals {
  bucket_name = "s3-bucket-pedram-company-website"
  region      = "eu-west-1"
}

module "s3-bucket" {
  source  = "app.terraform.io/pedram-company/s3-bucket/aws"
  tags{
    Owner = "pedramhamidehkhan"
  }
  acl    = "public-read"
    provisioner "local-exec" {
    command = "aws s3 sync static/ s3:/${bucket_name}.com --acl public-read --delete"
  }
website {
  index_document = "index.html"
}

}
# resource "aws_s3_bucket" "static" {
#   bucket = "pedramterraformexercie.com"
#   acl    = "public-read"
  
#   provisioner "local-exec" {
#     command = "aws s3 sync static/ s3://pedramterraformexercie.com --acl public-read --delete"
#   }

# website {
#   index_document = "index.html"
# }

# }