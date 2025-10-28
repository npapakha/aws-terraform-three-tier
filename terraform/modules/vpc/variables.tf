variable "region" {
  type        = string
  description = "AWS Region"
}

variable "availability_zones" {
  type        = list(string)
  description = "AWS Availability Zones"
}

variable "name" {
  type        = string
  description = "VPC Name"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "interface_endpoints" {
  type        = list(string)
  description = "List of interface endpoints to create"
}

variable "gateway_endpoints" {
  type        = list(string)
  description = "List of gateway endpoints to create"
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
