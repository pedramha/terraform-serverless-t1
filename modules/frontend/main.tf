provider "aws" {
  region = "eu-central-1"
}

module "aws_static_website" {
  source = "./${path.module}/static"

  website-domain-main     = "pedkopp92iasd.com"
  website-domain-redirect = "www.pedkopp92iasd.com"
  policy                  = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicRead",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${module.aws_static_website.website-domain-main}/*"
      }
    ]
  })
}
