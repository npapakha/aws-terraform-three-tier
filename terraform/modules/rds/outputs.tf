output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

output "db_name" {
  value = aws_db_instance.db_instance.db_name
}

output "kms_key_id" {
  value = aws_db_instance.db_instance.master_user_secret[0].kms_key_id
}

output "secret_arn" {
  value = aws_db_instance.db_instance.master_user_secret[0].secret_arn
}

output "secret_status" {
  value = aws_db_instance.db_instance.master_user_secret[0].secret_status
}
