variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "aws-service-monitoring"
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for CloudWatch log encryption"
  type        = string
  default     = null
} 