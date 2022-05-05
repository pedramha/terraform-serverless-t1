provider "aws" {
  region = "eu-west-1"
}


module "lambda_function_existing_package_local" {
  source = "app.terraform.io/pedram-company/lambda/aws"

  function_name = "order-receiver-service"
  description   = "microservice responsible for processing orders with private registry"
  runtime       = "nodejs12.x"
  handler       = "index.handler"

  create_package         = false
  local_existing_package = "${path.module}/lambdas.zip"

  tags = {
    "owner" = "pedram@hashicorp.com"
    "env"   = "dev"
  }
}


resource "random_pet" "lambda_bucket_name" {
  prefix = "pedrams"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
  tags = {
    "owner" = "pedram@hashicorp.com"
    "env"   = "dev"
  }
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
    "owner" = "pedram@hashicorp.com"
    "env"   = "dev"
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
    "owner" = "pedram@hashicorp.com"
    "env"   = "dev"
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
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
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
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:UpdateItem",
            "states:*"
          ],
          "Resource" : "*"
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
    "owner" = "pedram@hashicorp.com"
    "env"   = "dev"
  }
}

resource "aws_api_gateway_rest_api" "restapi" {
  name = "api-carsub"
  tags = {
    "owner" = "pedram@hashicorp.com"
    "env"   = "dev"
  }
}

//new resource for restapi
resource "aws_api_gateway_resource" "apiresource" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  parent_id   = aws_api_gateway_rest_api.restapi.root_resource_id
  path_part   = "order-car"
}
//new method for the resource
resource "aws_api_gateway_method" "apimethod" {
  rest_api_id   = aws_api_gateway_rest_api.restapi.id
  resource_id   = aws_api_gateway_resource.apiresource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.restapi.id
  resource_id             = aws_api_gateway_resource.apiresource.id
  http_method             = aws_api_gateway_method.apimethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.crud.invoke_arn
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"

  function_name = aws_lambda_function.crud.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.restapi.execution_arn}/*/*"
}
