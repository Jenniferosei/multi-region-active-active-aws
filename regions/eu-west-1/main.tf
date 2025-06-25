module "vpc_eu_west" {
  source          = "../../modules/vpc"
  name            = "multi-region-euw1"
  cidr            = "10.1.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  environment     = "prod"
}
