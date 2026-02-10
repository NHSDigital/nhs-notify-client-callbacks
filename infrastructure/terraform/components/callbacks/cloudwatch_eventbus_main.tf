resource "aws_cloudwatch_event_bus" "main" {
  name               = local.csi
  kms_key_identifier = module.kms.key_arn
}
