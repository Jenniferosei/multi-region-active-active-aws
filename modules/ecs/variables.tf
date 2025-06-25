variable "name" {
  description = "Base name for all resources"
  type        = string
}

variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "alb_security_group" {
  type = string
}

variable "fargate_security_group" {
  type = string
}

variable "execution_role_arn" {
  description = "IAM role for ECS task execution"
  type        = string
}

variable "container_image" {
  description = "Docker image to run"
  type        = string
}

variable "container_port" {
  description = "Port your container exposes"
  type        = number
}

variable "cpu" {
  default     = 256
  description = "Fargate CPU units"
  type        = number
}

variable "memory" {
  default     = 512
  description = "Fargate memory (MB)"
  type        = number
}
