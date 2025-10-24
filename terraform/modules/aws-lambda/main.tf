# Lambda

data "archive_file" "empty" {
  type = "zip"
  source {
    content  = "{}"
    filename = "index.js"
  }
  output_path = "/tmp/empty.zip"
}

resource "aws_lambda_function" "lambda_function" {
  function_name                  = var.function_name
  filename                       = data.archive_file.empty.output_path
  role                           = var.execution_role_arn
  handler                        = var.function_handler
  source_code_hash               = data.archive_file.empty.output_base64sha256
  architectures                  = [var.architecture]
  runtime                        = "nodejs22.x"
  reserved_concurrent_executions = var.reserved_concurrent_executions
  timeout                        = var.function_timeout

  environment {
    variables = var.environment
  }

  lifecycle {
    ignore_changes = [environment]
  }

  tags = var.tags
}
