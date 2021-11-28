# //application module
# module "application" {
#   source = "./modules/application"
# }

# resource "aws_api_gateway_rest_api" "restapi" {
#   name = "my-rest-api"
#   tags = {
#     "env" = "dev"
#   }
# }
# //new resource for restapi
# resource "aws_api_gateway_resource" "resource" {
#   rest_api_id = "${aws_api_gateway_rest_api.restapi.id}"
#   parent_id = "${aws_api_gateway_rest_api.restapi.root_resource_id}"
#   path_part = "my-resource"
# }
# //new method for the resource
# resource "aws_api_gateway_method" "method" {
#   rest_api_id = "${aws_api_gateway_rest_api.restapi.id}"
#   resource_id = "${aws_api_gateway_resource.resource.id}"
#   http_method = "POST"
#   authorization = "NONE"
# }


# //create an apigateway v2
# resource "aws_apigatewayv2_api" "terraapi" {
#   name          = "lambda api"
#   protocol_type = "HTTP"
#     tags = {
#     "env" = "dev"
#   }
# }

# //create a stage for the api gateway
# resource "aws_apigatewayv2_stage" "terraapi_stage" {
#   api_id        = aws_apigatewayv2_api.terraapi.id
#   name    = "prod"
#   # deployment_id = aws_apigatewayv2_deployment.terraapi.id
#   auto_deploy   = true
#   description   = "this is the prod stage"
#    tags = {
#     "env" = "dev"
#   }
# }

# resource "aws_apigatewayv2_integration" "hello_world" {
#   api_id = aws_apigatewayv2_api.terraapi.id

#   integration_uri    =  module.application.arn
#   integration_type   = "AWS_PROXY"
#   integration_method = "POST"
# }

# resource "aws_apigatewayv2_route" "hello_world" {
#   api_id = aws_apigatewayv2_api.terraapi.id

#   route_key = "GET /hello"
#   target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
# }

# resource "aws_lambda_permission" "api_gw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"

#   function_name = module.application.arn
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigatewayv2_api.terraapi.execution_arn}/*/*"

# }

# module "network" {
#   source = "./modules/network"

#   availability_zones = var.availability_zones
#   cidr_block         = var.cidr_block
# }

# module "business"{
#   source = "./modules/business"

# }