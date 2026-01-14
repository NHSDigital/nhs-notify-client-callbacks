module "client_destination" {
  source   = "../../modules/client-destination"
  for_each = local.clients_by_name

  project     = var.project
  aws_account_id = var.aws_account_id
  region = var.region
  component   = var.component
  environment = var.environment
  client_bus_name = aws_cloudwatch_event_bus.main.name

  kms_key_arn = module.kms.key_arn

  connection_name                  = each.value.connection_name
  destination_name                 = each.value.destination_name
  invocation_endpoint              = each.value.invocation_endpoint
  invocation_rate_limit_per_second = each.value.invocation_rate_limit_per_second
  http_method                      = each.value.http_method
  header_name                      = each.value.header_name
  header_value                     = each.value.header_value
  client_detail = each.value.client_detail




}
