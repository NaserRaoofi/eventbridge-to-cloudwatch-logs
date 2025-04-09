resource "aws_cloudwatch_log_metric_filter" "filters" {
  for_each = var.filters

  name           = each.key
  pattern        = each.value.pattern
  log_group_name = var.log_group_name

  metric_transformation {
    name          = each.value.metric_name
    namespace     = var.metric_namespace
    value         = each.value.metric_value
    default_value = each.value.default_value
  }
}

output "filter_names" {
  value = {
    for name, filter in aws_cloudwatch_log_metric_filter.filters : name => filter.id
  }
} 