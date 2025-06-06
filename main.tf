module "vpc" {
  source = "./vpc"
}

module "security-group" {
  source = "./security-group"
  vpc_id = module.vpc.vpc_id
}
/*
module "asg" {
  source = "./asg"
  vpc_zone_identifier = module.vpc.public_subnets
  security_group_id   = module.security-group.security_group_id
}

module "alb" {
  source = "./alb"
  vpc_id = module.vpc.vpc_id
  security_group = module.security-group.security_group_id
  public_subnets = module.vpc.public_subnets
}

/*resource "aws_lb_target_group" "test-target-group" {
  name     = "test-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}*/

# Create a new load balancer attachment
/*resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = module.asg.autoscaling_group_id
   lb_target_group_arn    = module.alb.target_id
}

*/
data "aws_ami" "terraform_ami" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-*-amd64-minimal-*]
  }


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_key_pair" "public_key" {
  key_name   = "terraform-key"
  public_key =  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzUBT9HRDJYhhS6rS1cqlXug/Wnv33UZbQ4UIHombPH jaspal.singh@monash.edu"
}


resource "aws_instance" "app" {
  count = 2

  ami           = data.aws_ami.terraform_ami.id
  instance_type = "t2.micro"

  subnet_id = var.public_subnets[count.index % length(var.public_subnets)]
  security_groups = module.security-group.security_group_id
}

