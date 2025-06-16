module "vpc" {
  source = "./vpc"
}

module "security-group" {
  #depends_on = [module.vpc]
  source = "./security-group"
  #vpc_id = module.vpc.vpc_id
}
/*
module "asg" {
  depends_on = [module.vpc, module.security-group]
  source = "./asg"
  vpc_zone_identifier = module.vpc.private_subnets
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
}*/

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

resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_instance_profile" "test_instance_profile"  {
  name = "test_instance_profile"
  role = aws_iam_role.test_role.name

}
resource "aws_instance" "example" {
  #depends_on = [aws_iam_role.test_role]
  count = var.instance_count * length(var.public_subnets)
  ami           = data.aws_ami.terraform_ami.id
  instance_type = "t2.micro"
  subnet_id     = module.security-group[count.index % length(var.public_subnets)]
  security_groups = [module.security-group.security_group_id]

  #iam_instance_profile = aws_iam_instance_profile.test_instance_profile.name

  tags = {
    Name = "tf-example"
  }
}
