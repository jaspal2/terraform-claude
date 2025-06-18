variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "private_subnets" {
    description  = "private subnets for vpc"
    type         = list(string)
    default      = ["10.0.1.0/24", "10.0.2.0/24"]   
}


variable "public_subnets" {
    description  = "Public subnets for vpc"
    type         = list(string)
    default      = ["10.0.101.0/24", "10.0.102.0/24"]   
}



variable "instance_name" {

  type = map(object({
    instance_type = string,
    tags           = map(string)
  }))
  default = {
    sandbox_one = {
      instance_type = "t2.small"
      tags = {
        Name = "sandbox_one"
      }
    }
}

}

variable "sandoxes" {
  type = map(object({
    instance_type = string,
    tags          = map(string)
  }))

  default = {
    sandox_1 = {
      instance_type = "",
      tags = {
        name = ""
      }
    }
  }
}



variable "map_understanding" {
  type = map(object({

  }))
  default = {
    sandbox_1 = {
      instance_type = "t2.micro",
      tags = {

      }
    }
  }
}


variable "ma_string" {
  type = map(string)
  default = {
    instance_name = "t2.micro"

  }
}