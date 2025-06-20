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

variable instance_count {
  type = number
  default = 2
}


variable "environmen" {
  type = string
  default = "prod"
}

variable "autoconfig" {
  type = map(object({
    name = string
    max_size = number
    min_size = number
    health_check_grace_period = number
    health_check_type         = string
    desired_capacity          = number
    force_delete              = bool
    scheduled_actions         = list(object({
      name             = string
          min_size         = number
          max_size         = number
          desired_capacity = number
          recurrence       = string
          time_zone        = string

    }))
  })),
  default = {
    app = {
      name = "autoscaling-test"
      max_size = 3
      min_size =  1
      health_check_grace_period = 300
      health_check_type         = "ELB"
      desired_capacity          = 2
      force_delete              = true,
      scheduled_actions = [
        {
          name             = "scale-up-morning"
          min_size         = 3
          max_size         = 12
          desired_capacity = 5
          recurrence       = "0 7 * * MON-FRI"
          time_zone        = "UTC"
        },
        {
          name             = "scale-down-evening"
          min_size         = 2
          max_size         = 8
          desired_capacity = 2
          recurrence       = "0 19 * * MON-FRI"
          time_zone        = "UTC"
        }
      ]
    }
  }
}