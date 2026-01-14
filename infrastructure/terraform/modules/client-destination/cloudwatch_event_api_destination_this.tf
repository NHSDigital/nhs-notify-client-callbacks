resource "aws_cloudwatch_event_api_destination" "main" {
  name                             = "${local.csi}-${var.destination_name}"
  description                      = "API Destination for ${var.destination_name}"
  invocation_endpoint              = var.invocation_endpoint
  http_method                      = var.http_method
  invocation_rate_limit_per_second = var.invocation_rate_limit_per_second
  connection_arn                   = aws_cloudwatch_event_connection.main.arn
}
