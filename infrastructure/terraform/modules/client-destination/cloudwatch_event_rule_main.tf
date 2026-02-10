resource "aws_cloudwatch_event_rule" "main" {
  name           = "${local.csi}-${var.connection_name}"
  description    = "Client Callbacks event rule for inbound events"
  event_bus_name = var.client_bus_name

  event_pattern = jsonencode({
    "detail" : {
      "type" : var.client_detail,
      "dataschemaversion" : [{
        "prefix" : "1."
      }]
    }
  })
}

resource "aws_cloudwatch_event_target" "main" {
  rule           = aws_cloudwatch_event_rule.main.name
  arn            = aws_cloudwatch_event_api_destination.main.arn
  target_id      = "${local.csi}-${var.connection_name}"
  role_arn       = aws_iam_role.api_target_role.arn
  event_bus_name = var.client_bus_name

  dead_letter_config {
    arn = module.target_dlq.sqs_queue_arn
  }
}
