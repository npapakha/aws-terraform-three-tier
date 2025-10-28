output "public_subnets" {
  value = values(aws_subnet.public_subnet)[*].id
}

output "app_subnets" {
  value = values(aws_subnet.app_subnet)[*].id
}

output "db_subnets" {
  value = values(aws_subnet.db_subnet)[*].id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "elb_security_groups" {
  value = [aws_security_group.elb_security_group.id]
}

output "app_security_groups" {
  value = [aws_security_group.app_security_group.id]
}

output "db_security_groups" {
  value = [aws_security_group.db_security_group.id]
}
