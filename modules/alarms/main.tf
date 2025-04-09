resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = var.alarms

  alarm_name          = each.key
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name        = each.value.metric_name
  namespace          = var.metric_namespace
  period             = each.value.metric_period
  statistic          = each.value.statistic
  threshold          = each.value.threshold
  treat_missing_data = each.value.treat_missing_data
  alarm_actions      = var.alarm_actions
  ok_actions         = var.ok_actions
}

output "alarm_arns" {
  description = "ARNs of the CloudWatch Alarms"
  value       = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.arn }
} 