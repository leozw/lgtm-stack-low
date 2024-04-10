output "iam-mimir-arn" {
  value = module.iam-mimir.arn
}

output "iam-tempo-arn" {
  value = module.iam-tempo.arn
}

output "iam-loki-arn" {
  value = module.iam-loki.arn
}

output "s3_bucket_name_loki" {
  value       = module.s3-loki.bucket-name
  description = "The name of the Loki S3 bucket."
}

output "s3_bucket_name_tempo" {
  value       = module.s3-tempo.bucket-name
  description = "The name of the Tempo S3 bucket."
}

output "s3_bucket_name_mimir" {
  value       = module.s3-mimir.bucket-name
  description = "The name of the Mimir S3 bucket."
}

output "s3_bucket_name_mimir_ruler" {
  value       = module.s3-mimir-ruler.bucket-name
  description = "The name of the Mimir Ruler S3 bucket."
}

output "aws_caller_identity_arn" {
  value       = data.aws_caller_identity.current.arn
  description = "The AWS ARN associated with the caller identity."
}

output "aws_caller_identity_user_id" {
  value       = data.aws_caller_identity.current.user_id
  description = "The user ID associated with the caller identity."
}

output "aws_caller_identity_account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "The AWS account ID associated with the caller identity."
}

output "aws_region_current_name" {
  value       = data.aws_region.current.name
  description = "The name of the current AWS region."
}

output "aws_region_current_endpoint" {
  value       = data.aws_region.current.endpoint
  description = "The endpoint URL of the current AWS region."
}
