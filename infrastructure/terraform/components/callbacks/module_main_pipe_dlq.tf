module "main_pipe_dlq" {
  source = "https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.29/terraform-sqs.zip"

  aws_account_id = var.aws_account_id
  component      = var.component
  environment    = var.environment
  project        = var.project
  region         = var.region
  name           = "main-pipe-dlq"

  sqs_kms_key_arn = module.kms.key_arn

  visibility_timeout_seconds = 60

  create_dlq = false

  sqs_policy_overload = data.aws_iam_policy_document.main_pipe_dlq.json
}

data "aws_iam_policy_document" "main_pipe_dlq" {
  statement {
    sid    = "AllowEventPipesToSendMessage"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pipes.amazonaws.com"]
    }

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      "arn:aws:pipe:${var.region}:${var.aws_account_id}:${local.csi}-main"
    ]
  }
}
