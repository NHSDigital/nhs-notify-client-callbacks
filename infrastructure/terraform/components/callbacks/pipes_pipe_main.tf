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
    dynamodb_stream_parameters {
      starting_position                  = "LATEST"
      maximum_record_age_in_seconds      = -1
      maximum_retry_attempts             = 3
      maximum_batching_window_in_seconds = 5
      dead_letter_config {
        arn = module.main_pipe_dlq.sqs_queue_arn
      }
    }
    filter_criteria {
      dynamic "filter" {
        for_each = var.pipe_event_patterns
        content {
          pattern = filter.value
        }
      }
    }
  }

  depends_on = [aws_iam_role_policy_attachment.main_pipe]
}
