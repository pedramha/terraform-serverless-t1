# output "function_name" {
#   description = "Name of the Lambda function."

#   value = aws_lambda_function.hello_world.function_name
# }

//output the api gateways url
output "api_url" {
  description = "URL of the API Gateway."

  value = aws_apigatewayv2_api.terraapi.api_endpoint
}