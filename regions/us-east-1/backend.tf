terraform {
  backend "s3" {
    bucket         = "multi-region-tf-state-bucket"
    key            = "us-east-1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
