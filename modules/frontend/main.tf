provider "aws" {
  region = "eu-central-1"
}

//static website on s3
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.pedokopp92iasd"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = "pedokopp92iasd"
    acl    = "public-read"

}