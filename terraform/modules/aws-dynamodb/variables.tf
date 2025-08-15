variable "table_name" {
  description = "DynamoDB table name."
  type        = string
}

variable "hash_key" {
  description = "DynamoDB table partition key."
  type        = string
}

variable "range_key" {
  description = "DynamoDB table sort key."
  type        = string
  default     = null
}

variable "billing_mode" {
  description = "DynamoDB table billing mode."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "tags" {
  description = "DynamoDB table tags."
  type        = map(string)
  default     = {}
}