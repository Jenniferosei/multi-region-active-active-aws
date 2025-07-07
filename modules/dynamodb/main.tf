resource "aws_dynamodb_table" "this" {
  provider     = aws
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "order_id"

  

  attribute {
    name = "order_id"
    type = "S"
  }

  replica {
    region_name = "eu-west-1"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  # Commenting this out temporarily
  # replication_group {
  #   region_name = "eu-west-1"
  # }

  tags = {
    Environment = "multi-region"
  }
}
