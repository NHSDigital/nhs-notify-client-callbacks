resource "aws_cloudwatch_event_connection" "main" {
  name               = "${local.csi}-${var.connection_name}"
  description        = "Event Connection which would be used by API Destination ${var.connection_name}"
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key   = var.header_name
      value = var.header_value
    }
  }
}
