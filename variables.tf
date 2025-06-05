variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}


variable "public_subnets" {
    description  = "Public subnets for vpc"
    type         = list(string)
    default      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}