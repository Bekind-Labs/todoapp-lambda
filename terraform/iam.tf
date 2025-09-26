# IAM Roles

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "dynamodb_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

data "aws_iam_policy" "basic_lambda_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_role_attachment_1" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = data.aws_iam_policy.dynamodb_full_access.arn
}

resource "aws_iam_role_policy_attachment" "lambda_role_attachment_2" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = data.aws_iam_policy.basic_lambda_execution_role.arn
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = format("%s/*/*%s", module.todo_api.execution_arn, module.todo_api.resource_path)
}