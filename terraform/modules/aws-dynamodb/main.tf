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

  dynamic "global_secondary_index" {
    for_each = (var.range_key != null && var.index_name != null) ? [{
      name : var.index_name,
      hash_key : var.range_key,
    }] : []
    content {
      name            = global_secondary_index.value["name"]
      hash_key        = global_secondary_index.value["hash_key"]
      projection_type = var.gsi_projection_type
    }
  }

  tags = var.tags
}
