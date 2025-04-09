locals {
  rule_name_prefix = "${var.project_name}-${var.environment}"
}

# EC2 Events Rule
resource "aws_cloudwatch_event_rule" "ec2_events" {
  count       = var.ec2_events_enabled ? 1 : 0
  name        = "${local.rule_name_prefix}-ec2-events"
  description = "Capture EC2 instance state changes"
  event_pattern = jsonencode(var.ec2_event_pattern)
}

# RDS Events Rule
resource "aws_cloudwatch_event_rule" "rds_events" {
  count       = var.rds_events_enabled ? 1 : 0
  name        = "${local.rule_name_prefix}-rds-events"
  description = "Capture RDS instance changes"
  event_pattern = jsonencode(var.rds_event_pattern)
}

# IAM Events Rule
resource "aws_cloudwatch_event_rule" "iam_events" {
  count       = var.iam_events_enabled ? 1 : 0
  name        = "${local.rule_name_prefix}-iam-events"
  description = "Capture IAM user and policy changes"
  event_pattern = jsonencode(var.iam_event_pattern)
}

# S3 Events Rule
resource "aws_cloudwatch_event_rule" "s3_events" {
  count       = var.s3_events_enabled ? 1 : 0
  name        = "${local.rule_name_prefix}-s3-events"
  description = "Capture S3 bucket changes"
  event_pattern = jsonencode(var.s3_event_pattern)
}

# CloudTrail Events Rule
resource "aws_cloudwatch_event_rule" "cloudtrail_events" {
  count       = var.cloudtrail_events_enabled ? 1 : 0
  name        = "${local.rule_name_prefix}-cloudtrail-events"
  description = "Capture CloudTrail events"
  event_pattern = jsonencode(var.cloudtrail_event_pattern)
}

# Security Hub Events Rule
resource "aws_cloudwatch_event_rule" "security_hub_events" {
  count       = var.security_hub_events_enabled ? 1 : 0
  name        = "${local.rule_name_prefix}-security-hub-events"
  description = "Capture Security Hub findings"
  event_pattern = jsonencode(var.security_hub_event_pattern)
}

# GuardDuty Events Rule
resource "aws_cloudwatch_event_rule" "guardduty_events" {
  count       = var.guardduty_events_enabled ? 1 : 0
  name        = "${local.rule_name_prefix}-guardduty-events"
  description = "Capture GuardDuty findings"
  event_pattern = jsonencode(var.guardduty_event_pattern)
}

# Event Targets for all rules
resource "aws_cloudwatch_event_target" "ec2_logs" {
  count     = var.ec2_events_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.ec2_events[0].name
  target_id = "SendToCloudWatchLogs"
  arn       = var.cloudwatch_log_group_arn
}

resource "aws_cloudwatch_event_target" "rds_logs" {
  count     = var.rds_events_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.rds_events[0].name
  target_id = "SendToCloudWatchLogs"
  arn       = var.cloudwatch_log_group_arn
}

resource "aws_cloudwatch_event_target" "iam_logs" {
  count     = var.iam_events_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.iam_events[0].name
  target_id = "SendToCloudWatchLogs"
  arn       = var.cloudwatch_log_group_arn
}

resource "aws_cloudwatch_event_target" "s3_logs" {
  count     = var.s3_events_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.s3_events[0].name
  target_id = "SendToCloudWatchLogs"
  arn       = var.cloudwatch_log_group_arn
}

resource "aws_cloudwatch_event_target" "cloudtrail_logs" {
  count     = var.cloudtrail_events_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.cloudtrail_events[0].name
  target_id = "SendToCloudWatchLogs"
  arn       = var.cloudwatch_log_group_arn
}

resource "aws_cloudwatch_event_target" "security_hub_logs" {
  count     = var.security_hub_events_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.security_hub_events[0].name
  target_id = "SendToCloudWatchLogs"
  arn       = var.cloudwatch_log_group_arn
}

resource "aws_cloudwatch_event_target" "guardduty_logs" {
  count     = var.guardduty_events_enabled ? 1 : 0
  rule      = aws_cloudwatch_event_rule.guardduty_events[0].name
  target_id = "SendToCloudWatchLogs"
  arn       = var.cloudwatch_log_group_arn
}

# Outputs
output "rule_arns" {
  value = {
    ec2         = var.ec2_events_enabled ? aws_cloudwatch_event_rule.ec2_events[0].arn : null
    rds         = var.rds_events_enabled ? aws_cloudwatch_event_rule.rds_events[0].arn : null
    iam         = var.iam_events_enabled ? aws_cloudwatch_event_rule.iam_events[0].arn : null
    s3          = var.s3_events_enabled ? aws_cloudwatch_event_rule.s3_events[0].arn : null
    cloudtrail  = var.cloudtrail_events_enabled ? aws_cloudwatch_event_rule.cloudtrail_events[0].arn : null
    security_hub = var.security_hub_events_enabled ? aws_cloudwatch_event_rule.security_hub_events[0].arn : null
    guardduty   = var.guardduty_events_enabled ? aws_cloudwatch_event_rule.guardduty_events[0].arn : null
  }
} 