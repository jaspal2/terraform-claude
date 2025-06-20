module "vpc" {
  source = "./vpc"
}

module "security-group" {
  depends_on = [module.vpc]
  source = "./security-group"
  vpc_id = module.vpc.vpc_id
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


locals {
  tags = {
    name = "test-env"
    environment = "dev"
    billing = "depart1"
  }
}

resource "aws_iam_instance_profile" "test_instance_profile"  {
  name = "test_instance_profile"
  role = aws_iam_role.test_role.name

}
resource "aws_instance" "example" {
  #depends_on = [aws_iam_role.test_role]
  count         = var.instance_count * length(var.public_subnets)
  ami           = data.aws_ami.terraform_ami.id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  security_groups = [module.security-group.security_group_id]
  associate_public_ip_address = (count.index%2 == 0 ? true : false)

  #iam_instance_profile = aws_iam_instance_profile.test_instance_profile.name

  tags = merge(local.tags)

}
*/


data "aws_availability_zones" "available_zone" {
  state = "available"
  filter {
    name = "zone-type"
    values = ["availability-zone"]
  }

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

locals {
  is_prod            = var.environmen == "prod"
  is_qa              = var.environmen  == "qa"
  az_count           =  length(data.aws_availability_zones.available_zone.names)

  instance_count     =  local.is_prod ? 3 : (local.is_qa ? 2 : 1)
  vpc_cidr = is_prod ? "10.0.0.0/16" : "10.${local.is_qa ? 1 : 2}.0.0/16"
  public_subnets = [
    for index in range(local.az_count):
            cidrsubnet(local.vpc_cidr, 8 , index+1 )
  ]
}


resource "aws_instance" "webserver" {
  #depends_on = [aws_iam_role.test_role]

  count =       local.instance_count * local.az_count
  ami           = data.aws_ami.terraform_ami.id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  security_groups = [module.security-group.security_group_id]
  associate_public_ip_address = (count.index%2 == 0 ? true : false)

  #iam_instance_profile = aws_iam_instance_profile.test_instance_profile.name
/*
  tags = merge(local., {
    "server" : "web-server"
  })*/

    }


resource "aws_instance" "app-server" {
  #depends_on = [aws_iam_role.test_role]

  count =       local.is_prod ? 2 : 1
  ami           = data.aws_ami.terraform_ami.id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  security_groups = [module.security-group.security_group_id]
  associate_public_ip_address = (count.index%2 == 0 ? true : false)

  #iam_instance_profile = aws_iam_instance_profile.test_instance_profile.name
/*
  tags = merge(local.tags, {
    "server" : "web-server"
  })*/

    }


