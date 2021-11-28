provider "aws" {
  region = "eu-central-1"
}

//s3 bucket for static web hosting
# resource "aws_s3_bucket" "static" {
#   bucket = "pedkopp92iasd.com"
#   acl    = "public-read"
#     provisioner "local-exec" {
#      command = "aws s3 cp ./static ${aws_s3_bucket.static.id}"
#   }
# }
