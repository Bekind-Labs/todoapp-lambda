variable "function_name" {
  description = "Lambda function name."
  type        = string
}

variable "function_handler" {
  description = "Lambda function handler."
  default     = "index.handler"
  type        = string
}

variable "execution_role_arn" {
  description = "Lambda Execution Role ARN."
  type        = string
}

variable "environment" {
  description = "Lambda function environment."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Lambda function tags."
  type        = map(string)
  default     = {}
}