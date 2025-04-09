resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.event_rules

  name           = each.value.name
  description    = each.value.description
  event_pattern  = each.value.event_pattern
  event_bus_name = each.value.event_bus_name

  tags = merge(var.tags, each.value.tags)
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = var.event_rules

  rule           = aws_cloudwatch_event_rule.this[each.key].name
  target_id      = "${each.key}-logs"
  arn            = var.cloudwatch_log_group_arn
  event_bus_name = aws_cloudwatch_event_rule.this[each.key].event_bus_name

  retry_policy {
    maximum_event_age_in_seconds = 86400  # 24 hours
    maximum_retry_attempts       = 3
  }
} 