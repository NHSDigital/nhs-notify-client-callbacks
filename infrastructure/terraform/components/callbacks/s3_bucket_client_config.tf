##
# S3 Bucket for Client Subscription Configuration
#
# Storage location for client subscription configurations loaded by Transform & Filter Lambda.
# Files are named {clientId}.json and contain ClientSubscriptionConfiguration arrays.
##

resource "aws_s3_bucket" "client_config" {
  bucket        = "${local.csi}-client-config"
  force_destroy = false

  tags = merge(
    local.default_tags,
    {
      Name        = "${local.csi}-client-config"
      Description = "Client subscription configuration storage"
    },
  )
}

resource "aws_s3_bucket_ownership_controls" "client_config" {
  bucket = aws_s3_bucket.client_config.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "client_config" {
  bucket = aws_s3_bucket.client_config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = module.kms.key_arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "client_config" {
  bucket = aws_s3_bucket.client_config.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "client_config" {
  depends_on = [
    aws_s3_bucket_policy.client_config
  ]

  bucket = aws_s3_bucket.client_config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##
# S3 Bucket Policy
#
# Allows EventBridge Pipes enrichment Lambda to read configuration files
##

resource "aws_s3_bucket_policy" "client_config" {
  bucket = aws_s3_bucket.client_config.id
  policy = data.aws_iam_policy_document.client_config_bucket.json
}

data "aws_iam_policy_document" "client_config_bucket" {
  statement {
    sid    = "AllowLambdaReadAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [module.client_transform_filter_lambda.lambda_role_arn]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.client_config.arn}/*",
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
      aws_s3_bucket.client_config.arn,
      "${aws_s3_bucket.client_config.arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
