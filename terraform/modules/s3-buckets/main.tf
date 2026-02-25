# 1. The Data Lake Bucket (Raw/Ingestion Zone)
resource "aws_s3_bucket" "data_lake" {
  bucket = "mia-dod-data-lake-${var.environment}-${var.account_id}"

  # Prevents accidental deletion of the entire bucket
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "MIA-DoD Data Lake"
    StorageTier = "Raw"
  }
}

# 2. Force Encryption at Rest (Using KMS)
resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake_encryption" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true # Reduces KMS costs for high-volume Glue jobs
  }
}

# 3. Enable Versioning (For Resilience/Recovery)
resource "aws_s3_bucket_versioning" "data_lake_versioning" {
  bucket = aws_s3_bucket.data_lake.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 4. The "Golden Guardrail": Block ALL Public Access
# This is a mandatory Treasury High requirement.
resource "aws_s3_bucket_public_access_block" "data_lake_block" {
  bucket = aws_s3_bucket.data_lake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}