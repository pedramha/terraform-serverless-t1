//static website on s3
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.pedokopp92iasd"
  acl    = "public-read"
  policy = templatefile("./s3-policy.json")

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name
  acl    = "pedokopp92iasd"
  policy = templatefile("./s3-policy.json")
}