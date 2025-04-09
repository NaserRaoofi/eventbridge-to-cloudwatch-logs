resource "aws_cloudwatch_metric_alarm" "alarms" {
  for_each = var.alarms

  alarm_name          = each.key
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = var.metric_namespace
  period             = each.value.period
  threshold          = each.value.threshold
  statistic          = "Sum"
  alarm_description  = each.value.alarm_description
  alarm_actions      = var.alarm_actions
  ok_actions         = var.ok_actions
  treat_missing_data = "notBreaching"
}

output "alarm_arns" {
  value = {
    for name, alarm in aws_cloudwatch_metric_alarm.alarms : name => alarm.arn
  }
} 