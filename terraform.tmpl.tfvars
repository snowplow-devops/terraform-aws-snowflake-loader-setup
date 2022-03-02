name                           = "snowplow"
stage_bucket                   = "snowplow-oss-bucket"
# The terraform-snowflake-target outputs
snowflake_database             = "SNOWPLOW_DATABASE"
snowflake_event_table          = "EVENTS"
snowflake_file_format          = "SNOWPLOW_ENRICHED_JSON"
snowflake_schema               = "ATOMIC"
snowflake_user                 = "snowplow"
# Account id to which storage integration will be linked to.
aws_account_id                 = "00000000"
