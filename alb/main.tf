
# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = module.asg.autoscaling_group_id
  elb                    = module.alb.alb_arn
}


module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "my-alb"
  vpc_id  = var.vpc_id
  subnets = var.public_subnets
  create_security_group = false
  security_groups = [var.security_group]
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

  }


}