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

variable "allowed_ip_addrs" {
  description = "List of Allowed IP addresses."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "API tags."
  type        = map(string)
  default     = {}
}