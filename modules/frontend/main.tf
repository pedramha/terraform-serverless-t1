provider "aws" {
  region = "eu-central-1"
}

module "aws_static_website" {
  source = "${path.module}/static"

  website-domain-main     = "pedkopp92iasd.com"
  website-domain-redirect = "www.pedkopp92iasd.com"
}

