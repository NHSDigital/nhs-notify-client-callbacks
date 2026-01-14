module "target_dlq" {
  source = "https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.29/terraform-sqs.zip"

  aws_account_id = var.aws_account_id
  component      = var.component
  environment    = var.environment
  project        = var.project
  region         = var.region
  name           = "${var.connection_name}-dlq"

  sqs_kms_key_arn = var.kms_key_arn

  visibility_timeout_seconds = 60

  create_dlq = false

  sqs_policy_overload = data.aws_iam_policy_document.target_dlq.json
}

data "aws_iam_policy_document" "target_dlq" {
  statement {
    sid    = "AllowEventBridgeToSendMessage"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      "arn:aws:sqs:${var.region}:${var.aws_account_id}:${var.project}-${var.environment}-${var.component}-${var.connection_name}-dlq"
    ]
  }
}
