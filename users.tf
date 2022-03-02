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
  database_name     = var.is_create_database ? snowflake_database.loader[0].name : local.db_name
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_file_format_grant" "loader" {
  database_name     = var.is_create_database ? snowflake_database.loader[0].name : local.db_name
  schema_name       = snowflake_schema.atomic.name
  file_format_name  = snowflake_file_format.enriched.name
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
  database_name     = var.is_create_database ? snowflake_database.loader[0].name : local.db_name
  schema_name       = snowflake_schema.atomic.name
  stage_name        = snowflake_stage.transformed.name
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_stage_grant" "folder_monitoring" {
  for_each          = toset(snowflake_stage.folder_monitoring[*].name)
  database_name     = var.is_create_database ? snowflake_database.loader[0].name : local.db_name
  schema_name       = snowflake_schema.atomic.name
  stage_name        = each.value
  privilege         = "USAGE"
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_schema_grant" "loader" {
  for_each          = toset([
    "CREATE TABLE",
    "CREATE TEMPORARY TABLE",
    "MODIFY",
    "USAGE"
  ])
  database_name     = var.is_create_database ? snowflake_database.loader[0].name : local.db_name
  schema_name       = snowflake_schema.atomic.name
  privilege         = each.key
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_table_grant" "loader" {
  for_each          = toset([
    "INSERT",
    "OWNERSHIP",
    "SELECT"
  ])
  database_name     = var.is_create_database ? snowflake_database.loader[0].name : local.db_name
  schema_name       = snowflake_schema.atomic.name
  table_name        = snowflake_table.events.name
  privilege         = each.key
  roles             = [snowflake_role.loader.name]
  with_grant_option = false
}

resource "snowflake_user" "loader" {
  name                 = local.snowflake_loader_user
  password             = var.snowflake_loader_password
  default_role         = snowflake_role.loader.name
  must_change_password = false
}

resource "snowflake_role_grants" "loader" {
  role_name = snowflake_role.loader.name
  users     = [snowflake_user.loader.name]
}
