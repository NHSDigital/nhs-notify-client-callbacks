resource "aws_iam_role" "api_target_role" {
  name               = "${local.csi}-api-target-target-role"
  description        = "Role for client target rule"
  assume_role_policy = data.aws_iam_policy_document.api_target_role_assume_role_policy.json
}

data "aws_iam_policy_document" "api_target_role_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "api_target_role" {
  role       = aws_iam_role.api_target_role.id
  policy_arn = aws_iam_policy.api_target_role.arn
}

resource "aws_iam_policy" "api_target_role" {
  name        = "${local.csi}-api-target-role-policy"
  description = "IAM Policy for the client target role"
  path        = "/"
  policy      = data.aws_iam_policy_document.api_target_role.json
}

data "aws_iam_policy_document" "api_target_role" {
  statement {
    sid    = replace("AllowAPIDestinationAccessFor${var.connection_name}", "-", "")
    effect = "Allow"

    actions = [
      "events:InvokeApiDestination",
    ]

    resources = [
      aws_cloudwatch_event_api_destination.main.arn
    ]
  }

  statement {
    sid    = replace("AllowSQSSendMessageForDLQFor${var.connection_name}", "-", "")
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    resources = [
      module.target_dlq.sqs_queue_arn,
    ]
  }

  statement {
    sid    = replace("AllowKMSForDLQFor${var.connection_name}", "-", "")
    effect = "Allow"

    actions = [
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt"
    ]

    resources = [
      var.kms_key_arn,
    ]
  }
}
