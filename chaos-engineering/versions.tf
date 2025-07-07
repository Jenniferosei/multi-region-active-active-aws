terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "jenny-bucket"
    region = "us-east-1"
    key    = "multi-region-fargate/chaos-engineering/chaos-engineering-eks.tfstate"
    encrypt = true
  }
}

