output "alb_dns_name" {
  value = module.ecs_us_east.alb_dns_name
}

output "alb_arn_use1" {
  value = module.ecs_us_east.lb_arn
}

output "global_accelerator_dns" {
  value = module.global_accelerator.global_accelerator_dns
}
