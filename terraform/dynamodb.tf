resource "aws_dynamodb_table" "carts" {
  name         = "${local.project_name}-carts"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.project_name}-carts"
      Service = "carts"
    }
  )
}
