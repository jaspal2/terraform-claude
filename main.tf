module "vpc" {
  source = "./vpc"
}

module "security-group" {
  depends_on = [module.vpc]
  source = "./security-group"
  vpc_id = module.vpc.vpc_id
}

module "asg" {
  depends_on = [module.vpc, module.security-group]
  source = "./asg"
  vpc_zone_identifier = module.vpc.p
  security_group_id   = module.security-group.security_group_id
}

module "alb" {
  depends_on = [module.vpc, module.security-group]
  source = "./alb"
  vpc_id = module.vpc.vpc_id
  security_group = module.security-group.security_group_id
  public_subnets = module.vpc.public_subnets
}

resource "aws_lb_target_group" "test-target-group" {
  name     = "test-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "example" {
  depends_on = [module.alb, module.asg]
  autoscaling_group_name = module.asg.autoscaling_group_id
   lb_target_group_arn    = module.alb.target_id
}

data "aws_ami" "terraform_ami" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-*-amd64-minimal-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = module.security-group.security_group_id
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}