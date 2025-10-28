variable "name" {
  type = string
}

variable "username" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "multi_az" {
  type = bool
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "storage_type" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "backup_retention_period" {
  type = number
}

variable "backup_window" {
  type = string
}

variable "maintenance_window" {
  type = string
}
