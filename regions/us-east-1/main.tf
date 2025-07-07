# provider "aws" {
#   alias  = "use1"
#   region = "us-east-1"
# }

# provider "aws" {
#   alias  = "euw1"
#   region = "eu-west-1"
# }

module "vpc_us_east" {
  source          = "../../modules/vpc"
  name            = "multi-region-use1"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  environment     = "prod"
}

module "global_accelerator" {
  source = "../../modules/global-accelerator"

  alb_arn_use1 = module.ecs_us_east.lb_arn
  # alb_arn_euw1 = module.ecs_eu_west.lb_arn
  alb_arn_euw1 = "arn:aws:elasticloadbalancing:eu-west-1:879381287275:loadbalancer/app/multi-region-use1-alb/3a53daeca7b8aadd"

}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP"
  vpc_id      = module.vpc_us_east.vpc_id

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
  vpc_id      = module.vpc_us_east.vpc_id

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


module "ecs_us_east" {
  source = "../../modules/ecs"

  name                   = "multi-region-use1"
  cluster_name           = "multi-region-use1"
  vpc_id                 = module.vpc_us_east.vpc_id
  public_subnets         = module.vpc_us_east.public_subnets
  private_subnets        = module.vpc_us_east.private_subnets
  alb_security_group     = aws_security_group.alb_sg.id
  fargate_security_group = aws_security_group.fargate_sg.id
  execution_role_arn     = aws_iam_role.ecs_task_execution.arn

  container_image        = "nginx:latest"
  container_port         = 80
  cpu                    = 256
  memory                 = 512
}


module "dynamodb_us_east" {
  source = "../../modules/dynamodb"

  providers = {
    aws = aws.use1
  }

  table_name      = "multi-region-orders"
  replica_regions = ["eu-west-1"]
  environment     = "multi-region"
}

module "s3" {
  source                  = "../../modules/s3"
  providers = {
    aws.use1 = aws.use1
    aws.euw1 = aws.euw1
  }
  source_bucket_name      = "multi-region-source-bucket-yourname"
  destination_bucket_name = "multi-region-destination-bucket-yourname"
}





