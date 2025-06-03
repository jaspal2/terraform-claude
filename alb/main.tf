
resource "aws_lb_target_group" "test-target-group" {
  name     = "test-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}


module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "my-alb"
  vpc_id  = var.vpc_id
  subnets = var.public_subnets
  create_security_group = false
  security_groups = [var.security_group]
  ip_address_type = "ipv4"
}