variable "name" {
  description = "A name which will be prepended to the created resources"
  type        = string

  validation {
    condition     = can(length(var.name) == 0)
    error_message = "Name could not be empty."
  }

  validation {
    condition     = !can(regex("-", var.name))
    error_message = "Name could not contain '-'."
  }
}

variable "snowflake_database" {
  description = "Snowflake database name"
  type        = string
}

variable "snowflake_schema" {
  description = "Snowflake schema name"
  type        = string
}

variable "snowflake_event_table" {
  description = "Snowflake events table name"
  type        = string
}

variable "snowflake_user" {
  description = "Snowflake username"
  type        = string
}

variable "snowflake_file_format" {
  description = "Snowflake file format name"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account id for the role to be linked with storage integration. Role itself won't be created by this module"
  type        = string

  validation {
    condition     = can(regex("^\\d+$", var.aws_account_id))
    error_message = "AWS account consists of numbers."
  }
}

variable "stage_bucket" {
  description = "Name of the S3 bucket which will be used as stage by Snowflake"
  type        = string
}

variable "snowflake_wh_size" {
  description = "Size of the Snowflake warehouse to connect to"
  default     = "XSMALL"
  type        = string
}

variable "folder_monitoring_enabled" {
  description = "Folder monitoring loading"
  type        = bool
  default     = false
}

variable "snowflake_wh_auto_suspend" {
  description = "Time period to wait before suspending warehouse"
  default     = 60
  type        = number
}

variable "snowflake_wh_auto_resume" {
  description = "Whether to enable auto resume which makes automatically resume the warehouse when any statement that requires a warehouse is submitted "
  default     = true
  type        = bool
}

variable "override_snowflake_wh_name" {
  description = "Override warehouse name, if not set it will be defaulted to uppercase var.name with \"_WAREHOUSE\" suffix"
  default     = ""
  type        = string
}

variable "override_folder_monitoring_stage_url" {
  description = "Override monitoring stage url, if not set it will be defaulted \"s3://$${var.stage_bucket_name}/$${var.name}/shredded/v1\""
  default     = ""
  type        = string
}

variable "override_transformed_stage_url" {
  description = "Override transformed stage url, if not set it will be defaulted \"s3://$${var.stage_bucket_name}/$${var.name}/monitoring\""
  default     = ""
  type        = string
}

variable "override_snowflake_loader_user" {
  description = "Override loader user name in snowflake, if not set it will be uppercase var.name with _LOADER_USER suffix"
  default     = ""
  type        = string
}

variable "override_snowflake_loader_role" {
  description = "Override loader role name in snowflake, if not set it will be uppercase var.name with \"_LOADER_ROLE\" suffix"
  default     = ""
  type        = string
}

variable "override_iam_loader_role_name" {
  description = "Override integration iam role name, if not set it will be var.name with -snowflakedb-load-role suffix"
  default     = ""
  type        = string
}
