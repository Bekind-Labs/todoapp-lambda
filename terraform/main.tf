variable "table_name" {
  type    = string
  default = "todo_table"
}

variable "function_name" {
  type = string
  default = "todo_lambda"
}

variable "api_name" {
  type = string
  default = "todo_api"
}

variable "allowed_ip_addrs" {
  type = list(string)
  default = ["1.2.3.4/32"]
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
  function_name      = var.function_name
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
  api_name          = var.api_name
  api_stage         = "dev"
  allowed_ip_addrs = var.allowed_ip_addrs
  lambda_invoke_arn = module.todo_lambda.invoke_arn
  tags              = var.tags
}

output "todo_api_id" {
  value = module.todo_api.api_id
}

output "todo_api_invoke_url" {
  value = module.todo_api.invoke_url
}
