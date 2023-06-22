[![Release][release-image]][release] [![CI][ci-image]][ci] [![License][license-image]][license] [![Registry][registry-image]][registry] [![Source][source-image]][source]

# terraform-aws-snowflake-loader-setup

A Terraform module for preparing snowflake for loading snowplow data. Should be used after the `terraform-snowflake-target`.

## Deprecation notice

**This module is now deprecated.**

To configure the Snowflake Loader on AWS please follow the [guide here](https://docs.snowplow.io/docs/getting-started-on-snowplow-open-source/quick-start-aws).

## Prerequisites

Authentication for the service user is required for the snowflake terraform provider - [follow this tutorial][snowflake-service-user-tutorial] to obtain snowflake connection details:

| Parameter | Description |
|------|---------|
| account | The account name. |
| username | A snowflake user to perform resource creation.|
| region | Region for the snowflake deployment. |
| role | Needs to be ACCOUNTADMIN or similar. |
| private_key_path | Path the private key. |

## Usage

### Applying module directly

1. Fill variables in [terraform.tfvars.tmpl](terraform.tfvars.tmpl) and copy it to `terraform.tfvars`.
2. Using environment variables for authentication as [described in here][snowflake-env-vars].  Fill the template in [snowflake_provider_vars.sh](snowflake_provider_vars.sh) and run `source ./snowflake_provider_vars.sh` to set up your local environment.
3. Run `terraform init`
4. Run `terraform apply`

### Using the module from another module

Pass authentication parameters directly to Snowflake provider.

```hcl
provider "snowflake" {
  username         = "my_user"
  account          = "my_account"
  region           = "us-west-2"
  role             = "ACCOUNTADMIN"
  private_key_path = "/path/to/private/key"
}

module "snowflake_target" {
   source = "snowplow-devops/target/snowflake"
   
   name               = "snowplow"
   snowflake_password = "example_password"
}

module "snowflake_setup" {
   source = "snowplow-devops/snowflake-loader-setup/aws"

   name                  = "snowplow"
   stage_bucket          = "snowplow-oss-bucket"
   aws_account_id        = "0000000000"
   snowflake_database    = module.snowflake_target.snowflake_database
   snowflake_event_table = module.snowflake_target.snowflake_event_table
   snowflake_file_format = module.snowflake_target.snowflake_file_format
   snowflake_schema      = module.snowflake_target.snowflake_schema
   snowflake_user        = module.snowflake_target.snowflake_user
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | >= 0.45.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | >= 0.45.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [snowflake_database_grant.loader](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database_grant) | resource |
| [snowflake_file_format_grant.loader](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/file_format_grant) | resource |
| [snowflake_integration_grant.loader](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/integration_grant) | resource |
| [snowflake_role.loader](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/role) | resource |
| [snowflake_role_grants.loader](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/role_grants) | resource |
| [snowflake_schema_grant.loader](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/schema_grant) | resource |
| [snowflake_stage.folder_monitoring](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/stage) | resource |
| [snowflake_stage.transformed](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/stage) | resource |
| [snowflake_stage_grant.folder_monitoring](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/stage_grant) | resource |
| [snowflake_stage_grant.transformed](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/stage_grant) | resource |
| [snowflake_storage_integration.integration](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/storage_integration) | resource |
| [snowflake_table_grant.loader](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/table_grant) | resource |
| [snowflake_warehouse.loader](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/warehouse) | resource |
| [snowflake_warehouse_grant.loader](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/warehouse_grant) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account id for the role to be linked with storage integration. Role itself won't be created by this module | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | A name which will be prepended to the created resources | `string` | n/a | yes |
| <a name="input_snowflake_database"></a> [snowflake\_database](#input\_snowflake\_database) | Snowflake database name | `string` | n/a | yes |
| <a name="input_snowflake_event_table"></a> [snowflake\_event\_table](#input\_snowflake\_event\_table) | Snowflake events table name | `string` | n/a | yes |
| <a name="input_snowflake_file_format"></a> [snowflake\_file\_format](#input\_snowflake\_file\_format) | Snowflake file format name | `string` | n/a | yes |
| <a name="input_snowflake_schema"></a> [snowflake\_schema](#input\_snowflake\_schema) | Snowflake schema name | `string` | n/a | yes |
| <a name="input_snowflake_user"></a> [snowflake\_user](#input\_snowflake\_user) | Snowflake username | `string` | n/a | yes |
| <a name="input_stage_bucket"></a> [stage\_bucket](#input\_stage\_bucket) | Name of the S3 bucket which will be used as stage by Snowflake | `string` | n/a | yes |
| <a name="input_folder_monitoring_enabled"></a> [folder\_monitoring\_enabled](#input\_folder\_monitoring\_enabled) | Folder monitoring loading | `bool` | `false` | no |
| <a name="input_override_folder_monitoring_stage_url"></a> [override\_folder\_monitoring\_stage\_url](#input\_override\_folder\_monitoring\_stage\_url) | Override monitoring stage url, if not set it will be defaulted "s3://${var.stage\_bucket\_name}/${var.name}/shredded/v1" | `string` | `""` | no |
| <a name="input_override_iam_loader_role_name"></a> [override\_iam\_loader\_role\_name](#input\_override\_iam\_loader\_role\_name) | Override integration iam role name, if not set it will be var.name with -snowflakedb-load-role suffix | `string` | `""` | no |
| <a name="input_override_snowflake_loader_role"></a> [override\_snowflake\_loader\_role](#input\_override\_snowflake\_loader\_role) | Override loader role name in snowflake, if not set it will be uppercase var.name with "\_LOADER\_ROLE" suffix | `string` | `""` | no |
| <a name="input_override_snowflake_loader_user"></a> [override\_snowflake\_loader\_user](#input\_override\_snowflake\_loader\_user) | Override loader user name in snowflake, if not set it will be uppercase var.name with \_LOADER\_USER suffix | `string` | `""` | no |
| <a name="input_override_snowflake_wh_name"></a> [override\_snowflake\_wh\_name](#input\_override\_snowflake\_wh\_name) | Override warehouse name, if not set it will be defaulted to uppercase var.name with "\_WAREHOUSE" suffix | `string` | `""` | no |
| <a name="input_override_transformed_stage_url"></a> [override\_transformed\_stage\_url](#input\_override\_transformed\_stage\_url) | Override transformed stage url, if not set it will be defaulted "s3://${var.stage\_bucket\_name}/${var.name}/monitoring" | `string` | `""` | no |
| <a name="input_snowflake_wh_auto_resume"></a> [snowflake\_wh\_auto\_resume](#input\_snowflake\_wh\_auto\_resume) | Whether to enable auto resume which makes automatically resume the warehouse when any statement that requires a warehouse is submitted | `bool` | `true` | no |
| <a name="input_snowflake_wh_auto_suspend"></a> [snowflake\_wh\_auto\_suspend](#input\_snowflake\_wh\_auto\_suspend) | Time period to wait before suspending warehouse | `number` | `60` | no |
| <a name="input_snowflake_wh_size"></a> [snowflake\_wh\_size](#input\_snowflake\_wh\_size) | Size of the Snowflake warehouse to connect to | `string` | `"XSMALL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_storage_integration_role_arn"></a> [aws\_iam\_storage\_integration\_role\_arn](#output\_aws\_iam\_storage\_integration\_role\_arn) | AWS storage integration IAM role ARN |
| <a name="output_aws_iam_storage_integration_role_name"></a> [aws\_iam\_storage\_integration\_role\_name](#output\_aws\_iam\_storage\_integration\_role\_name) | AWS storage integration IAM role name |
| <a name="output_aws_iam_storage_integration_user_arn"></a> [aws\_iam\_storage\_integration\_user\_arn](#output\_aws\_iam\_storage\_integration\_user\_arn) | AWS storage integration IAM user ARN |
| <a name="output_aws_s3_bucket_name"></a> [aws\_s3\_bucket\_name](#output\_aws\_s3\_bucket\_name) | Name of the S3 bucket which will be used as stage by Snowflake |
| <a name="output_aws_s3_folder_monitoring_stage_url"></a> [aws\_s3\_folder\_monitoring\_stage\_url](#output\_aws\_s3\_folder\_monitoring\_stage\_url) | AWS bucket url of folder monitoring stage |
| <a name="output_aws_s3_transformed_stage_url"></a> [aws\_s3\_transformed\_stage\_url](#output\_aws\_s3\_transformed\_stage\_url) | AWS bucket url of transformed stage |
| <a name="output_aws_storage_external_id"></a> [aws\_storage\_external\_id](#output\_aws\_storage\_external\_id) | AWS external id |
| <a name="output_snowflake_loader_role"></a> [snowflake\_loader\_role](#output\_snowflake\_loader\_role) | Snowflake role for loading snowplow data |
| <a name="output_snowflake_monitoring_stage_name"></a> [snowflake\_monitoring\_stage\_name](#output\_snowflake\_monitoring\_stage\_name) | Name of monitoring stage |
| <a name="output_snowflake_transformed_stage_name"></a> [snowflake\_transformed\_stage\_name](#output\_snowflake\_transformed\_stage\_name) | Name of transformed stage |
| <a name="output_snowflake_warehouse"></a> [snowflake\_warehouse](#output\_snowflake\_warehouse) | Snowflake warehouse name |

# Copyright and license

The Terraform Snowflake Loader Setup project is Copyright 2022-2022 Snowplow Analytics Ltd.

Licensed under the [Apache License, Version 2.0][license] (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[snowflake-service-user-tutorial]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#2
[snowflake-env-vars]: https://quickstarts.snowflake.com/guide/terraforming_snowflake/index.html?index=..%2F..index#3

[release]: https://github.com/snowplow-devops/terraform-aws-snowflake-loader-setup/releases/latest
[release-image]: https://img.shields.io/github/v/release/snowplow-devops/terraform-aws-snowflake-loader-setup

[ci]: https://github.com/snowplow-devops/terraform-aws-snowflake-loader-setup/actions?query=workflow%3Aci
[ci-image]: https://github.com/snowplow-devops/terraform-aws-snowflake-loader-setup/workflows/ci/badge.svg

[license]: https://www.apache.org/licenses/LICENSE-2.0
[license-image]: https://img.shields.io/badge/license-Apache--2-blue.svg?style=flat

[registry]: https://registry.terraform.io/modules/snowplow-devops/snowflake-loader-setup/aws/latest
[registry-image]: https://img.shields.io/static/v1?label=Terraform&message=Registry&color=7B42BC&logo=terraform

[source]: https://github.com/snowplow/snowplow-rdb-loader
[source-image]: https://img.shields.io/static/v1?label=Snowplow&message=Snowflake%20Loader&color=0E9BA4&logo=GitHub
