module "vpc" {
  source = "./vpc"
}

module "security-group" {
  source = "./security-group"
  vpc_id = module.vpc.vpc_id
}

