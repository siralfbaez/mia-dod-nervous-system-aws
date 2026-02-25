variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_id" {
  description = "The VPC where the Nervous System resides"
  type        = string
}

variable "private_subnet_ids" {
  description = "Subnets for Glue and Aurora"
  type        = list(string)
}

variable "endpoint_sg_id" {
  description = "Security Group for VPC Endpoints"
  type        = string
}