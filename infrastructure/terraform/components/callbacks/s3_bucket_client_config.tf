##
# S3 Bucket for Client Subscription Configuration
#
# Storage location for client subscription configurations loaded by Transform & Filter Lambda.
# Files are named {clientId}.json and contain ClientSubscriptionConfiguration arrays.
##

module "client_config_bucket" {
  source = "https://github.com/NHSDigital/nhs-notify-shared-modules/releases/download/v2.0.28/terraform-s3bucket.zip"

  name = "client-config"

  aws_account_id = var.aws_account_id
  component      = var.component
  environment    = var.environment
  project        = var.project
  region         = var.region

  default_tags = merge(
    local.default_tags,
    {
      Description = "Client subscription configuration storage"
    }
  )

  kms_key_arn        = module.kms.key_arn
  force_destroy      = false
  versioning         = true
  object_ownership   = "BucketOwnerPreferred"
  bucket_key_enabled = true

  policy_documents = [
    data.aws_iam_policy_document.client_config_bucket.json
  ]
}

##
# S3 Bucket Policy
#
# Allows Transform & Filter Lambda to read configuration files
##

data "aws_iam_policy_document" "client_config_bucket" {
  statement {
    sid    = "AllowLambdaReadAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [module.client_transform_filter_lambda.iam_role_arn]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${module.client_config_bucket.arn}/*",
    ]
  }

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      module.client_config_bucket.arn,
      "${module.client_config_bucket.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
