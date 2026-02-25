# 1. The Master Encryption Key
resource "aws_kms_key" "mia_dod_key" {
  description             = "Master key for MIA-DoD Nervous System data and logs"
  deletion_window_in_days = 30
  enable_key_rotation     = true # Mandatory for Treasury/FedRAMP compliance

  tags = {
    Name = "mia-dod-cmk"
  }
}

# 2. The Key Alias (For easier reference in Glue/S3)
resource "aws_kms_alias" "mia_dod_key_alias" {
  name          = "alias/mia-dod-nervous-system"
  target_key_id = aws_kms_key.mia_dod_key.key_id
}

# 3. The Key Policy (The "Guardrail")
# This defines WHO can use the key. We grant access to the Glue Role we created.
resource "aws_kms_key_policy" "mia_dod_key_policy" {
  key_id = aws_kms_key.mia_dod_key.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "mia-dod-kms-policy"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Glue Service to Use Key"
        Effect = "Allow"
        Principal = {
          AWS = var.glue_role_arn
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}