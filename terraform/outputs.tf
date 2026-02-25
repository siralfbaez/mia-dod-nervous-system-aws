output "s3_bucket_name" {
  value = module.storage.data_lake_bucket_name
}

output "kms_key_arn" {
  value = module.kms.key_arn
}

output "glue_role_arn" {
  value = module.iam.glue_role_arn
}

output "db_endpoint" {
  value = module.database.cluster_endpoint
}