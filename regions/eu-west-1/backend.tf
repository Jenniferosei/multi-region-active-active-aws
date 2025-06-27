terraform {
  backend "s3" {
    bucket         = "multi-region-tf-state-bucket-euw1"
    key            = "eu-west-1/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
