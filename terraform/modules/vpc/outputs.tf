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
  value = aws_vpc.main.id
}
