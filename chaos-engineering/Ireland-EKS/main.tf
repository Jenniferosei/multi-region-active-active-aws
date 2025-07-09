# # provider "aws" {
# #   region = "us-east-1"
# # }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.8.4"

#   cluster_name    = "chaos-engineering"
#   cluster_version = "1.28"
#   subnet_ids      = var.public_subnet_ids
#   vpc_id          = var.vpc_id

#   eks_managed_node_groups = {
#     default = {
#       instance_types = ["t3.medium"]
#       min_size       = 1
#       max_size       = 2
#       desired_size   = 1
#     }
#   }

#   enable_irsa = true
# }
locals {
  name = var.name

  tags = {
    Resource_Name = local.name
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.11"

  cluster_name                          = local.name
  cluster_version                       = "1.32"
  cluster_endpoint_public_access        = true
  cluster_endpoint_private_access       = true
  enable_cluster_creator_admin_permissions = true

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # EKS Addons 
  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids

  eks_managed_node_groups = {
    private_node_group = {
      name           = "chaos-engineering"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1

      tags = {
        Name = "chaos-engineering-ireland-worker-node"
      }
    }
  }
}



