# CloudWatch Log Group resource
resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id
  tags              = var.tags
}

# Outputs
output "arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.arn
}

output "name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.name
} 