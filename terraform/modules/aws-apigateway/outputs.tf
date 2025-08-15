output "api_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}

output "invoke_url" {
  value = aws_api_gateway_stage.rest_api_stage.invoke_url
}
