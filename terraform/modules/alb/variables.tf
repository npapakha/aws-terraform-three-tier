variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "port" {
  type = number
}

variable "target_port" {
  type = number
}

variable "target_protocol" {
  type = string
}
