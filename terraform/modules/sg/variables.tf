variable "vpc_id" {
  type = string
}

variable "app_name" {
  type = string
}

variable "elb_ports" {
  type = list(object({ port = number, protocol = string }))
}

variable "app_ports" {
  type = list(object({ port = number, protocol = string }))
}

variable "db_ports" {
  type = list(object({ port = number, protocol = string }))
}
