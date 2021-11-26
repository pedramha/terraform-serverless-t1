
data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/hello-world"
  output_path = "${path.module}/hello-world.zip"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "kooooppp9i"
  acl           = "private"
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
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
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

resource "aws_lambda_function" "myLambdaFunc" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_hello_world.key

  runtime = "nodejs12.x"
  handler = "hello.handler"

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256
  role = aws_iam_role.iam_for_lambda.arn
}


//create a dynamodb
# resource "aws_dynamodb_table" "mytable" {
#   name = "mytable"
#   read_capacity_units = 1
#   write_capacity_units = 1
# }

//create an apigateway v2
resource "aws_apigatewayv2_api" "terraapi" {
  name          = "lambda api"
  protocol_type = "HTTP"
}

//create a stage for the api gateway
resource "aws_apigatewayv2_stage" "terraapi_stage" {
  api_id        = aws_apigatewayv2_api.terraapi.id
  name    = "prod"
  # deployment_id = aws_apigatewayv2_deployment.terraapi.id
  auto_deploy   = true
  description   = "this is the prod stage"
}

# //create lambda integration
# resource "aws_apigatewayv2_integration" "terraapi_int" {
#   api_id             = aws_apigatewayv2_api.terraapi.id
#   integration_method = "POST"
#   integration_type   = "AWS_PROXY"
#   integration_uri    = aws_lambda_function.myLambdaFunc.invoke_arn
# }
# //api route
# resource "aws_apigatewayv2_route" "terraapi_int" {
#   api_id      = aws_apigatewayv2_api.terraapi.id
#   route_key   = "GET /hello"
#   target = "integration/${aws_apigatewayv2_integration.terraapi_int.id}"
# }

resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.terraapi.id

  integration_uri    = aws_lambda_function.myLambdaFunc.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.terraapi.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.myLambdaFunc.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.terraapi.execution_arn}/*/*"
}

//create a step function
resource "aws_iam_role" "iam_for_step_function" {
  name = "iam_for_step_function"
  assume_role_policy = file("stepfuncpolicy.json")
  # jsonencode({
  #   "Version" : "2012-10-17",
  #   "Statement" : [{
  #     "Action" : "sts:AssumeRole",
  #     "Principal" : {
  #       "Service" : "states.amazonaws.com"
  #     },
  #     "Effect" : "Allow",
  #     "Sid" : ""
  #   }]
  # })
}

# resource "aws_iam_role" "test" {
#   name= "test"
#   assume_role_policy = file("test.json")
# }

//create an external iam role for lambda functions to dynamodb

# terraform graph | dot -Tsvg > graph.svg

//create step functions state machine from external file
resource "aws_sfn_state_machine" "my_state_machine" {
  name = "my_state_machine"
  //arn:aws:lambda:eu-central-1:833915806704:function:HelloWorld
  role_arn = aws_iam_role.iam_for_step_function.arn
  definition = file("stepfunc.json.asl")
}