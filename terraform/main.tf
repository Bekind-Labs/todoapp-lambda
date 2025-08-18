variable "table_name" {
  type    = string
  default = "todo_table"
}

variable "tags" {
  type = map(string)
  default = {
    Application = "todo"
    Environment = "production"
  }
}

module "todo_lambda" {
  source             = "./modules/aws-lambda"
  function_name      = "todo_lambda"
  execution_role_arn = aws_iam_role.lambda_execution_role.arn
  environment = {
    DYNAMODB_TABLE_NAME = var.table_name
  }
  tags = var.tags
}

module "todo_table" {
  source     = "./modules/aws-dynamodb"
  table_name = var.table_name
  hash_key   = "id"
  tags       = var.tags
}

module "todo_api" {
  source            = "./modules/aws-apigateway"
  api_name          = "todo_api"
  api_path          = "todos"
  api_stage         = "dev"
  lambda_invoke_arn = module.todo_lambda.invoke_arn
  tags              = var.tags
}
