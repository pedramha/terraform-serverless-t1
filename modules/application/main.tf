
data "archive_file" "lambda_hello_world" {
  type = "zip"
  source_dir  = "./hello-world"
  output_path = "./hello-world.zip"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "kooooppp9i"
  acl           = "private"
  tags        = {
    "Name" = "hello-world"
  }
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket_public_access" {
  bucket = aws_s3_bucket.lambda_bucket.id
  block_public_acls    = true
  block_public_policy  = true
}

resource "aws_s3_bucket_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello-world_sdfsdfsdfsdfSD.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
  tags        = {
    "Name" = "hello-world"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  tags        = {
    "Name" = "hello-world"
  }
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "Service" : "lambda.amazonaws.com"
      },
      "Effect" : "Allow",
      "Sid" : ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_hello_world.key

  runtime = "nodejs12.x"
  handler = "hello.handler"

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256
  role = aws_iam_role.iam_for_lambda.arn
  tags        = {
    "Name" = "hello-world"
  }
}

