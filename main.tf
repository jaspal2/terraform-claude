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
}