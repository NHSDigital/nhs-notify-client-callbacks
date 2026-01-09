resource "aws_iam_role_policy_attachment" "main_pipe" {
  role       = aws_iam_role.main_pipe.id
  policy_arn = aws_iam_policy.main_pipe.arn
}

resource "aws_iam_policy" "main_pipe" {
  name        = "${local.csi}-main-pipe-policy"
  description = "IAM Policy for the client subscriptions status pipe"
  path        = "/"
  policy      = data.aws_iam_policy_document.main_pipe.json
}

#trivy:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "main_pipe" {
  statement {
    sid    = "AllowSQSAccess"
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
    "sqs:DeleteMessage",
    "sqs:GetQueueAttributes",
    "sqs:ChangeMessageVisibility"
    ]

    resources = [
      module.sqs_inbound_event.sqs_queue_arn
    ]
  }

  statement {
    sid    = "AllowEventBusAccess"
    effect = "Allow"

    actions = [
      "events:PutEvents"
    ]

    resources = [
      aws_cloudwatch_event_bus.main.arn
    ]
  }

  statement {
    sid    = "AllowKMSAccess"
    effect = "Allow"

    actions = [
      "kms:ReEncrypt*",
      "kms:GetKeyPolicy",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt"
    ]

    resources = [
      module.kms.key_arn
    ]
  }

  statement {
    sid    = "AllowLambdaAccess"
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction"
    ]

    resources = [
      module.client_transform_filter_lambda.function_arn
    ]
  }

  statement {
    sid    = "AllowDlqAccess"
    effect = "Allow"

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      module.main_pipe_dlq.sqs_queue_arn
    ]
  }
}
