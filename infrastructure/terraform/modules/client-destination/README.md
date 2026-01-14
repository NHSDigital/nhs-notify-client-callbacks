<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable -->
<!-- vale off -->

## Requirements

No requirements.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | Account ID | `string` | n/a | yes |
| <a name="input_client_bus_name"></a> [client\_bus\_name](#input\_client\_bus\_name) | EventBus name where you create the rule | `string` | n/a | yes |
| <a name="input_client_detail"></a> [client\_detail](#input\_client\_detail) | Client Event Detail | `list(string)` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | Component name | `string` | n/a | yes |
| <a name="input_connection_name"></a> [connection\_name](#input\_connection\_name) | Connection name | `string` | n/a | yes |
| <a name="input_destination_name"></a> [destination\_name](#input\_destination\_name) | Destination Name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the tfscaffold environment | `string` | n/a | yes |
| <a name="input_header_name"></a> [header\_name](#input\_header\_name) | Header name | `string` | n/a | yes |
| <a name="input_header_value"></a> [header\_value](#input\_header\_value) | Header value | `string` | n/a | yes |
| <a name="input_http_method"></a> [http\_method](#input\_http\_method) | HTTP Method | `string` | n/a | yes |
| <a name="input_invocation_endpoint"></a> [invocation\_endpoint](#input\_invocation\_endpoint) | Invocation Endpoint | `string` | n/a | yes |
| <a name="input_invocation_rate_limit_per_second"></a> [invocation\_rate\_limit\_per\_second](#input\_invocation\_rate\_limit\_per\_second) | Invocation Rate Limit Per Second | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS Key ARN | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The name of the tfscaffold project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_target_dlq"></a> [target\_dlq](#module\_target\_dlq) | https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.29/terraform-sqs.zip | n/a |
## Outputs

No outputs.
<!-- vale on -->
<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->
