resource "snowflake_storage_integration" "integration" {
  name                      = "${upper(var.name)}_SNOWFLAKE_STORAGE_INTEGRATION"
  type                      = "EXTERNAL_STAGE"
  enabled                   = true
  storage_allowed_locations = ["s3://${var.stage_bucket}/"]
  storage_provider          = "S3"
  storage_aws_role_arn      = local.snowflake_iam_load_role_arn
}

resource "snowflake_warehouse" "loader" {
  name           = local.wh_name
  warehouse_size = var.snowflake_wh_size
  auto_suspend   = var.snowflake_wh_auto_suspend
  auto_resume    = var.snowflake_wh_auto_resume
}

resource "snowflake_stage" "transformed" {
  name                = local.transformed_stage_name
  url                 = local.transformed_stage_url
  database            = var.snowflake_database
  schema              = var.snowflake_schema
  storage_integration = snowflake_storage_integration.integration.name
  file_format         = "FORMAT_NAME = \"${var.snowflake_database}\".\"${var.snowflake_schema}\".${var.snowflake_file_format}"
}

resource "snowflake_stage" "folder_monitoring" {
  count               = var.folder_monitoring_enabled ? 1 : 0
  name                = local.folder_monitoring_stage_name
  url                 = local.folder_monitoring_stage_url
  database            = var.snowflake_database
  schema              = var.snowflake_schema
  storage_integration = snowflake_storage_integration.integration.name
  file_format         = "FORMAT_NAME = \"${var.snowflake_database}\".\"${var.snowflake_schema}\".${var.snowflake_file_format}"
}
