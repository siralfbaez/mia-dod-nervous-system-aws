# 1. The Trust Policy: Allows AWS Glue to assume this role
resource "aws_iam_role" "glue_service_role" {
  name = "mia-dod-glue-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Description = "Service role for MIA-DoD Glue ETL jobs with Least Privilege access"
  }
}

# 2. Least Privilege Policy: Access only to specific S3 buckets and KMS keys
resource "aws_iam_policy" "glue_data_access" {
  name        = "mia-dod-glue-data-access-policy"
  description = "Provides restricted access to S3 and KMS for MIA-DoD pipelines"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::mia-dod-data-lake-*",
          "arn:aws:s3:::mia-dod-data-lake-*/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = [var.kms_key_arn]
      }
    ]
  })
}

# 3. Attach the custom policy and the AWS standard service policy
resource "aws_iam_role_policy_attachment" "custom_data_access" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.glue_data_access.arn
}

resource "aws_iam_role_policy_attachment" "glue_service_standard" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
