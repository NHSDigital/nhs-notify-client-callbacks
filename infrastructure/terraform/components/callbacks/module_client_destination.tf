module "client_destination" {
  source   = "../../modules/client-destination"
  for_each = local.clients_by_name

  project     = var.project
  component   = var.component
  environment = var.environment

  connection_name                  = each.value.connection_name
  destination_name                 = each.value.destination_name
  invocation_endpoint              = each.value.invocation_endpoint
  invocation_rate_limit_per_second = each.value.invocation_rate_limit_per_second
  http_method                      = each.value.http_method
  header_name                      = each.value.header_name
  header_value                     = each.value.header_value


}
