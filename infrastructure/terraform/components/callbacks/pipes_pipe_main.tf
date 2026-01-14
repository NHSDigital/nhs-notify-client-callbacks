resource "aws_pipes_pipe" "main" {
  name               = "${local.csi}-main"
  role_arn           = aws_iam_role.main_pipe.arn
  source             = module.sqs_inbound_event.sqs_queue_arn
  target             = aws_cloudwatch_event_bus.main.arn
  enrichment         = module.client_transform_filter_lambda.function_arn
  kms_key_identifier = module.kms.key_arn
  log_configuration {
    level = "ERROR"
    cloudwatch_logs_log_destination {
      log_group_arn = aws_cloudwatch_log_group.main_pipe.arn
    }
  }
  source_parameters {
    sqs_queue_parameters {
      batch_size                         = var.pipe_sqs_input_batch_size
      maximum_batching_window_in_seconds = var.pipe_sqs_max_batch_window
    }
  }

      target_parameters {
      eventbridge_event_bus_parameters {

      }

      input_template = <<EOF
{
  "dataschemaversion": <$.body.dataschemaversion>,
  "type": <$.body.type>
}
EOF
    }

  depends_on = [aws_iam_role_policy_attachment.main_pipe]
}
