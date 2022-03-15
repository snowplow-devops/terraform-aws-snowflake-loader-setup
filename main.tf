locals {
  wh_name                      = var.override_snowflake_wh_name != "" ? var.override_snowflake_wh_name : "${upper(var.name)}_WAREHOUSE"
  snowflake_loader_user        = var.override_snowflake_loader_user != "" ? var.override_snowflake_loader_user : "${upper(var.name)}_LOADER_USER"
  snowflake_loader_role        = var.override_snowflake_loader_role != "" ? var.override_snowflake_loader_role : "${upper(var.name)}_LOADER_ROLE"
  transformed_stage_name       = "${upper(var.name)}_TRANSFORMED_STAGE"
  transformed_stage_url        = var.override_transformed_stage_url != "" ? var.override_transformed_stage_url : "s3://${var.stage_bucket}/tranformed/good"
  folder_monitoring_stage_name = "${upper(var.name)}_FOLDER_MONITORING_STAGE"
  folder_monitoring_stage_url  = var.override_folder_monitoring_stage_url != "" ? var.override_folder_monitoring_stage_url : "s3://${var.stage_bucket}/${var.name}/monitoring"
  snowflake_iam_load_role_name = var.override_iam_loader_role_name != "" ? var.override_iam_loader_role_name : "${var.name}-snowflakedb-load-role"
  snowflake_iam_load_role_arn  = "arn:aws:iam::${var.aws_account_id}:role/${local.snowflake_iam_load_role_name}"
}
