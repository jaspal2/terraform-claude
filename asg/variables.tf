variable "min_size" {
  description = "Minimum instance in an ASG"
  type        = string
  default     = 1
}

variable "max_size" {
  description = "Maximum instances in ASG"
  type        = string
  default     = 2
}


variable "vpc_zone_identifier" {
  description =  "Subnet where to launch instances"
  type        =  list(string)
}

variable "launch_template_name" {
  type       = string
  default    = "Terraform launch template"
}

variable "public_key" {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzUBT9HRDJYhhS6rS1cqlXug/Wnv33UZbQ4UIHombPH jaspal.singh@monash.edu"
}