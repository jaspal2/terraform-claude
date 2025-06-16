data "aws_availability_zones" "available_zones" {
  all_availability_zones = true
  state                   = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available_zones.names, 0 , 2)
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