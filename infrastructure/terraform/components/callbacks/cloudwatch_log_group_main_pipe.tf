resource "aws_cloudwatch_log_group" "main_pipe" {
  name              = "/aws/vendedlogs/pipes/${local.csi}-main"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = module.kms.key_arn

  tags = merge(
    local.default_tags,
    {
      Name = local.csi
    },
  )
}
