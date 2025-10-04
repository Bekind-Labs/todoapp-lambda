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
  function_name    = var.function_name
  filename         = data.archive_file.empty.output_path
  role             = var.execution_role_arn
  handler          = var.function_handler
  source_code_hash = data.archive_file.empty.output_base64sha256
  runtime          = "nodejs22.x"
  architectures    = ["arm64"]

  environment {
    variables = var.environment
  }

  tags = var.tags
}
