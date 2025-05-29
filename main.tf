module "vpc" {
  source = "./vpc"
}

module "security-group" {
  source = "./security-group"
  vpc_id = module.vpc.vpc_id
}

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