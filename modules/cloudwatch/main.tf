variable "name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain log events"
  type        = number
  default     = 30
}

variable "kms_key_id" {
  description = "ARN of the KMS key to use for log encryption"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the log group"
  type        = map(string)
  default     = {}
}

resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id
  tags              = var.tags
}

output "arn" {
  value = aws_cloudwatch_log_group.this.arn
}

output "name" {
  value = aws_cloudwatch_log_group.this.name
} 