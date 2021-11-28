provider "aws" {
  region = "eu-central-1"
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
}

resource "aws_lambda_function" "crud" {
  function_name = "lambda-crud"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.crud_lambda.key

  runtime = "nodejs12.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.crud_lambda.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
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
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:*",
                "logs:*",
                "dynamodb:*"
            ],
            "Resource": "*"
        }
    ]
}
  )
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
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
}
# resource "aws_lambda_event_source_mapping" "event_source_mapping" {
#   batch_size        = 100
#   event_source_arn  = "${aws_dynamodb_table.ddbtable.arn}"
#   enabled           = true
#   function_name     = "${aws_lambda_function.crud.function_name}"
#   starting_position = "TRIM_HORIZON"
# }
//create dynamodb


# resource "aws_iam_role_policy" "lambda_policy" {
#   name = "lambda_policy"
#   role = aws_iam_role.role_for_LDC.id

#   policy = file("./modules/application/policy.json")
# }


# resource "aws_iam_role" "role_for_LDC" {
#   name = "myrole"

#   assume_role_policy = file("./modules/application/assume_role_policy.json")

# }

# module "aws_lambda_function" {
#   source = "terraform-aws-modules/lambda/aws"

#   function_name = "lambda"
#   description   = "My awesome lambda function"
#   handler       = "index.handler"
#   runtime       = "nodejs12.x"

#   source_path = "./modules/application/lambdas/index.js"

#   }
# data "aws_lambda_function" "lambda_name" {
#   function_name = "lambda"
# }

# output "arn" {
#   value = data.aws_lambda_function.lambda_name.arn
# }
# resource "aws_lambda_function" "lambda" {

#   function_name = "func"
#   s3_bucket = aws_s3_bucket.lambda_bucket.id
#   s3_key    = aws_s3_bucket_object.archive_file.key
#   source_code_hash = data.archive_file.archive_file.output_base64sha256
#   role          = aws_iam_role.role_for_LDC.arn
#   handler       = "index.handler"
#   runtime       = "nodejs12.x"
# }
