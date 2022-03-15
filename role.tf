resource "snowflake_role" "loader" {
  name = local.snowflake_loader_role
}

resource "snowflake_warehouse_grant" "loader" {
  for_each          = toset(["MODIFY", "MONITOR", "USAGE", "OPERATE"])
  warehouse_name    = snowflake_warehouse.loader.name
  privilege         = each.key
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_database_grant" "loader" {
  database_name     = var.snowflake_database
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_file_format_grant" "loader" {
  database_name     = var.snowflake_database
  schema_name       = var.snowflake_schema
  file_format_name  = var.snowflake_file_format
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_integration_grant" "loader" {
  integration_name  = snowflake_storage_integration.integration.name
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_stage_grant" "transformed" {
  database_name     = var.snowflake_database
  schema_name       = var.snowflake_schema
  stage_name        = snowflake_stage.transformed.name
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_stage_grant" "folder_monitoring" {
  for_each          = toset(snowflake_stage.folder_monitoring[*].name)
  database_name     = var.snowflake_database
  schema_name       = var.snowflake_schema
  stage_name        = each.value
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_schema_grant" "loader" {
  for_each = toset([
    "CREATE TABLE",
    "CREATE TEMPORARY TABLE",
    "MODIFY",
    "USAGE"
  ])
  database_name     = var.snowflake_database
  schema_name       = var.snowflake_schema
  privilege         = each.key
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_table_grant" "loader" {
  for_each = toset([
    "INSERT",
    "OWNERSHIP",
    "SELECT"
  ])
  database_name     = var.snowflake_database
  schema_name       = var.snowflake_schema
  table_name        = var.snowflake_event_table
  privilege         = each.key
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_role_grants" "loader" {
  role_name = snowflake_role.loader.name
  users     = [var.snowflake_user]
}
