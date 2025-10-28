variable "aws_ecr_url" {
  type = string
}

variable "aws_db_secret" {
  type = string
}

variable "aws_lb_target_group_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "memory" {
  type = number
}

variable "cpu" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "port" {
  type = number
}

variable "environment" {
  type = list(object({ name = string, value = string }))
}
