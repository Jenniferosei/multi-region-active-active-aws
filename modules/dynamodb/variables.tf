variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table"
}

variable "replica_regions" {
  type        = list(string)
  default     = []
  description = "Regions where this table should be replicated"
}

variable "environment" {
  type        = string
  description = "Environment tag"
}
