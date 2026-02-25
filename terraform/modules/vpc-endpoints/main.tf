# Interface Endpoints (Powered by AWS PrivateLink)
# These allow private communication to services like Glue, SageMaker, and KMS

resource "aws_vpc_endpoint" "glue" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.glue"
  vpc_endpoint_type = "Interface"

  security_group_ids = [var.endpoint_sg_id]
  subnet_ids         = var.private_subnet_ids

  private_dns_enabled = true

  tags = {
    Name = "mia-dod-glue-endpoint"
  }
}

resource "aws_vpc_endpoint" "kms" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.kms"
  vpc_endpoint_type = "Interface"

  security_group_ids = [var.endpoint_sg_id]
  subnet_ids         = var.private_subnet_ids

  private_dns_enabled = true

  tags = {
    Name = "mia-dod-kms-endpoint"
  }
}

# Gateway Endpoint for S3
# S3 uses a 'Gateway' type which is free and highly performant for big data loads

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids

  tags = {
    Name = "mia-dod-s3-endpoint"
  }
}
