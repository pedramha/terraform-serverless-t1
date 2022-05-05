provider "aws" {
  region = "eu-central-1"
}


module "lambda_function_existing_package_local" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-existing-package-local"
  description   = "My awesome lambda function"
  runtime = "nodejs12.x"
  handler = "index.handler"

  create_package         = false
  local_existing_package = "existing_package.zip"
}


resource "random_pet" "lambda_bucket_name" {
  prefix = "learn-terraform-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
}

data "archive_file" "crud_lambda" {
  type = "zip"

  source_dir  = "${path.module}/lambdas"
  output_path = "${path.module}/lambdas.zip"
}

resource "aws_s3_bucket_object" "crud_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "lambdas.zip"
  source = data.archive_file.crud_lambda.output_path

  etag = filemd5(data.archive_file.crud_lambda.output_path)
    tags = {
    "env" = "dev"
  }
}

resource "aws_lambda_function" "crud" {
  function_name = "lambda-crud"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.crud_lambda.key

  runtime = "nodejs12.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.crud_lambda.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
    tags = {
    "env" = "dev"
  }
}

resource "aws_cloudwatch_log_group" "crud" {
  name = "/aws/lambda/${aws_lambda_function.crud.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  )
}

//policy for lambda to dynamo
resource "aws_iam_policy" "lambda_dynamo" {
  name = "serverless_lambda_dynamo"

  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:UpdateItem",            
            "states:*"
          ],
          "Resource": "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_dynamo.arn
}


//create dynamodb table
resource "aws_dynamodb_table" "ddbtable" {
  name         = "myDB"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
    tags = {
    "env" = "dev"
  }
}
