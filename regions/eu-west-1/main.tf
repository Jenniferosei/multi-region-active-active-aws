provider "aws" {
  alias  = "euw1"
  region = "eu-west-1"
}

module "vpc_eu_west" {
  source          = "../../modules/vpc"
  name            = "multi-region-euw1"
  cidr            = "10.1.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  environment     = "prod"
}



data "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP"
  vpc_id      = module.vpc_eu_west.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "fargate_sg" {
  name        = "fargate-sg"
  description = "Allow from ALB"
  vpc_id      = module.vpc_eu_west.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "ecs_eu_west" {
  source = "../../modules/ecs"
  providers = {
    aws = aws.euw1
  }

  name                   = "multi-region-use1"
  cluster_name           = "multi-region-use1"
  vpc_id                 = module.vpc_eu_west.vpc_id
  public_subnets         = module.vpc_eu_west.public_subnets
  private_subnets        = module.vpc_eu_west.private_subnets
  alb_security_group     = aws_security_group.alb_sg.id
  fargate_security_group = aws_security_group.fargate_sg.id
  execution_role_arn     =  data.aws_iam_role.ecs_task_execution.arn

  container_image        = "nginx:latest"
  container_port         = 80
  cpu                    = 256
  memory                 = 512
}


# If you ever need to reference it later
output "ecs_cluster_arn_euw1" {
  value = module.ecs_eu_west.ecs_cluster_arn
}


module "dynamodb_eu_west" {
  source = "../../modules/dynamodb"

  providers = {
    aws = aws.euw1
  }

  table_name      = "multi-region-orders"
  replica_regions = []  # No replicas from Ireland
  environment     = "multi-region"
}


 