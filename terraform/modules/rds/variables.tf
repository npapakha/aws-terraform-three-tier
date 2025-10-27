variable "db_name" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "username" {
  type    = string
  default = "postgres"
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "17.6"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group IDs"
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "backup_window" {
  type    = string
  default = "03:00-06:00"
}

variable "maintenance_window" {
  type    = string
  default = "Mon:00:00-Mon:03:00"
}
