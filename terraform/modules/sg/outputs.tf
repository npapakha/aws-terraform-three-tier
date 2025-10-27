output "elb_security_group_id" {
  value = aws_security_group.elb_security_group.id
}

output "app_security_group_id" {
  value = aws_security_group.app_security_group.id
}

output "db_security_group_id" {
  value = aws_security_group.db_security_group.id
}
