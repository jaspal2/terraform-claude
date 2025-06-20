data "aws_availability_zones" "available_zones" {
  all_availability_zones = true
  state                   = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

locals {
  vpc_cidr = var.vpc_cidr
  az_count = length(data.aws_availability_zones.available_zones.names)
  public_subnets = [
  for index in range(local.az_count):
          cidrsubnet(local.vpc_cidr, 8, index+1 )
  ]

  private_subnets = [
      for index in range(local.az_count):
          cidrsubnet(local.vpc_cidr, 8, index+10 )
  ]
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available_zones.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  map_public_ip_on_launch = true
  enable_nat_gateway = false
  create_private_nat_gateway_route = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}