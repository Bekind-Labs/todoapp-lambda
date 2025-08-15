# DynamoDB Table

resource "aws_dynamodb_table" "todo_table" {
  name      = var.table_name
  hash_key  = var.hash_key
  range_key = var.range_key

  billing_mode = var.billing_mode

  dynamic "attribute" {
    for_each = var.range_key != null ? [var.hash_key, var.range_key] : [var.hash_key]
    content {
      name = attribute.value
      type = "S"
    }
  }

  tags = var.tags
}
