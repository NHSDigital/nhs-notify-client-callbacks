resource "aws_iam_role" "main_pipe" {
  name               = "${local.csi}-main-pipe"
  description        = "Role for client callbacks pipe"
  assume_role_policy = data.aws_iam_policy_document.main_pipe_assume_role_policy.json
}

data "aws_iam_policy_document" "main_pipe_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["pipes.amazonaws.com"]
    }
  }
}
