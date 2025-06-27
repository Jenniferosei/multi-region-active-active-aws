

resource "aws_globalaccelerator_accelerator" "this" {
  name               = "multi-region-ecs-accelerator"
  ip_address_type    = "IPV4"
  enabled            = true
}


resource "aws_globalaccelerator_listener" "http" {
  accelerator_arn = aws_globalaccelerator_accelerator.this.id
  port_range {
    from_port = 80
    to_port   = 80
  }
  protocol = "TCP"
  client_affinity = "NONE"
}

# Optional: Add HTTPS listener
# resource "aws_globalaccelerator_listener" "https" {
#   accelerator_arn = aws_globalaccelerator_accelerator.this.id
#   port_range {
#     from_port = 443
#     to_port   = 443
#   }
#   protocol = "TCP"
#   client_affinity = "NONE"
# }

# Endpoint Group for us-east-1
resource "aws_globalaccelerator_endpoint_group" "use1" {
  listener_arn = aws_globalaccelerator_listener.http.id
  endpoint_group_region = "us-east-1"

  endpoint_configuration {
    # endpoint_id = "arn:aws:elasticloadbalancing:us-east-1:879381287275:loadbalancer/app/multi-region-use1-alb/24b86654cb7956df"
    # endpoint_id = var.alb.alb_arn_use1
    endpoint_id = var.alb_arn_use1

    weight      = 128
  }

  health_check_path     = "/"
  health_check_protocol = "HTTP"
  health_check_port     = 80
  threshold_count       = 3
  traffic_dial_percentage = 100
}

# Endpoint Group for eu-west-1
resource "aws_globalaccelerator_endpoint_group" "euw1" {
  listener_arn = aws_globalaccelerator_listener.http.id
  endpoint_group_region = "eu-west-1"

  endpoint_configuration {
    # endpoint_id = "arn:aws:elasticloadbalancing:eu-west-1:879381287275:loadbalancer/app/multi-region-use1-alb/3a53daeca7b8aadd"
    # endpoint_id = var.alb.alb_arn_euw1
    endpoint_id = var.alb_arn_euw1

    weight      = 128
  }

  health_check_path     = "/"
  health_check_protocol = "HTTP"
  health_check_port     = 80
  threshold_count       = 3
  traffic_dial_percentage = 100
}

output "global_accelerator_dns" {
  value = aws_globalaccelerator_accelerator.this.dns_name
  description = "Use this DNS to access your ECS service via Global Accelerator"
}
