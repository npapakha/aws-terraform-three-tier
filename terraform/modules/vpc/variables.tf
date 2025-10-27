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
