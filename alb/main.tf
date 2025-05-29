resource "aws_lb_target_group" "test_target_group" {
  name     = "test-taget-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
}


module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "my-alb"
  vpc_id  = var.vpc_id
  subnets = var.public_subnets
  create_security_group = false
  security_groups = var.security_group
  ip_address_type = "ipv4"

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"

      forward = {
        target_group_key = "ex-instance"
      }
    }
  }


}