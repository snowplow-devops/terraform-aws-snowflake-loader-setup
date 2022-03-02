output "snowflake_loader_role" {
  description = "Snowflake role for loading snowplow data"
  value       = local.snowflake_loader_role
}

output "snowflake_warehouse" {
  description = "Snowflake warehouse name"
  value       = local.wh_name
}

output "snowflake_transformed_stage_name" {
  description = "Name of transformed stage"
  value       = local.transformed_stage_name
}

output "snowflake_monitoring_stage_name" {
  description = "Name of monitoring stage"
  value       = local.folder_monitoring_stage_name
}

output "aws_s3_transformed_stage_url" {
  description = "AWS bucket url of transformed stage"
  value       = snowflake_stage.transformed.url
}

output "aws_s3_folder_monitoring_stage_url" {
  description = "AWS bucket url of folder monitoring stage"
  value       = join("", snowflake_stage.folder_monitoring[*].url)
}

output "aws_s3_bucket_name" {
  description = "Name of the S3 bucket which will be used as stage by Snowflake"
  value       = var.stage_bucket
}

output "aws_storage_external_id" {
  description = "AWS external id"
  value       = snowflake_storage_integration.integration.storage_aws_external_id
}

output "aws_iam_storage_integration_role_arn" {
  description = "AWS storage integration IAM role ARN"
  value       = local.snowflake_iam_load_role_arn
}

output "aws_iam_storage_integration_user_arn" {
  description = "AWS storage integration IAM user ARN"
  value       = snowflake_storage_integration.integration.storage_aws_iam_user_arn
}

output "aws_iam_storage_integration_role_name" {
  description = "AWS storage integration IAM role name"
  value       = local.snowflake_iam_load_role_name
}

