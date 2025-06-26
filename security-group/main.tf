

module "terraform_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["https-443-tcp",  "ssh-tcp", "http-80-tcp"]
  egress_rules              = ["all-all"]
}

module "web-sg" {
   source = "terraform-aws-modules/security-group/aws"

  name        = "web-sg"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules            = ["https-443-tcp",  "ssh-tcp", "http-80-tcp"]
  egress_rules              = ["all-all"]
  tags = {
    "name" : "${var.env}-web-sg"
  }
}


module "app-server-sg" {
   source = "terraform-aws-modules/security-group/aws"

  name        = "app-sg"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = var.vpc_id
   computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.web-sg.security_group_id
    }
  ]

  egress_rules              = ["all-all"]

  tags = {
    "name" : "${var.env}-app-sg"
  }
}