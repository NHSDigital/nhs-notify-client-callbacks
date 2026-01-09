resource "aws_cloudwatch_event_bus" "main" {
  name = "${local.csi}-callbacks"
}
