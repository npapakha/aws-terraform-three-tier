variable "region" {
  type    = string
  default = "us-east-1"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/18"
}

variable "elb_port" {
  type    = number
  default = 80
}

variable "app_name" {
  type    = string
  default = "petstore"
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "app_desired_count" {
  type    = number
  default = 2
}

variable "app_memory" {
  type    = number
  default = 512
}

variable "app_cpu" {
  type    = number
  default = 256
}

variable "db_username" {
  type    = string
  default = "postgres"
}

variable "db_multi_az" {
  type    = bool
  default = true
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_engine_version" {
  type    = string
  default = "17.6"
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_storage_type" {
  type    = string
  default = "gp2"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_backup_retention_period" {
  type    = number
  default = 7
}

variable "db_backup_window" {
  type    = string
  default = "03:00-06:00"
}

variable "db_maintenance_window" {
  type    = string
  default = "Mon:00:00-Mon:03:00"
}
