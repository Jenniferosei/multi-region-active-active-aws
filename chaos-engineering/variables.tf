

# variable "vpc_id" {
#   description = "The VPC ID where the EKS cluster will be created"
#   type        = string
#   default     = "vpc-04552e53db4b0f43a"
# }



# variable "public_subnet_ids" {
#   description = "List of public subnet IDs in the VPC"
#   type        = list(string)
#   default     = [
#      "subnet-09d6af6522bad8117",
#   "subnet-0d858120afb6e04f9"
#   ] # List of public subnets
# }

# variable "name" {
#   description = "The name of the EKS cluster"
#   type        = string
#   default     = "Chaos-Engineering"
# }

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

# variable "region" {
#   description = "AWS region to deploy to"
#   type        = string
# }

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}
