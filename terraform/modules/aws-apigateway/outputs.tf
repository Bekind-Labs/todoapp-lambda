output "api_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.rest_api.execution_arn
}

output "resource_path" {
  value = aws_api_gateway_resource.rest_api_resource.path
}

output "invoke_url" {
  value = aws_api_gateway_stage.rest_api_stage.invoke_url
}
