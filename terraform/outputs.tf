output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "db_secret_arn" {
  value = module.rds.secret_arn
}

output "elb_dns_name" {
  value = module.alb.lb_dns_name
}
