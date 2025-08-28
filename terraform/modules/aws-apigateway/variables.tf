variable "api_name" {
  description = "API name."
  type        = string
}

variable "api_stage" {
  description = "API stage."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Lambda function invoke arn."
  type        = string
}

variable "tags" {
  description = "API tags."
  type        = map(string)
  default     = {}
}