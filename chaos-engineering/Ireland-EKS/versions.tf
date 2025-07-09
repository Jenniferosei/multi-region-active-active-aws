terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "jen-bucket-ireland"
    region = "eu-west-1"
    key    = "multi-region-fargate/chaos-engineering-ireland/chaos-engineering-eks.tfstate"
    encrypt = true
  }
}

