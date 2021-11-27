//create a dynamodb
# resource "aws_dynamodb_table" "mytable" {
#   name = "mytable"
#   read_capacity_units = 1
#   write_capacity_units = 1
# }

//application module
module "application" {
  source = "./modules/application"
}

//create an apigateway v2
resource "aws_apigatewayv2_api" "terraapi" {
  name          = "lambda api"
  protocol_type = "HTTP"
  tags        = {
    "Name" = "hello-world"
  }
}

//create a stage for the api gateway
resource "aws_apigatewayv2_stage" "terraapi_stage" {
  api_id        = aws_apigatewayv2_api.terraapi.id
  name    = "prod"
  # deployment_id = aws_apigatewayv2_deployment.terraapi.id
  auto_deploy   = true
  description   = "this is the prod stage"
  tags        = {
    "Name" = "hello-world"
  }
}



resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.terraapi.id

  integration_uri    =  module.application.arn
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

  function_name = module.application.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.terraapi.execution_arn}/*/*"
}

module "network" {
  source = "./modules/network"

  availability_zones = var.availability_zones
  cidr_block         = var.cidr_block
}

module "business"{
  source = "./modules/business"
}



