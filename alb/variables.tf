variable "vpc_id" {
  type = string
}

variable "security_group" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}