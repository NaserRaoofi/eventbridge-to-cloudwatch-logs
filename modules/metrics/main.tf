variable "name" {
  description = "Name prefix for metric filters"
  type        = string
}

variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "filters" {
  description = "Map of metric filters to create"
  type = map(object({
    pattern        = string
    metric_name    = string
    metric_value   = string
    default_value  = string
  }))
}

resource "aws_cloudwatch_log_metric_filter" "filters" {
  for_each = var.filters

  name           = "${var.name}-${each.key}"
  pattern        = each.value.pattern
  log_group_name = var.log_group_name

  metric_transformation {
    name          = each.value.metric_name
    namespace     = "Custom/ServiceMonitoring"
    value         = each.value.metric_value
    default_value = each.value.default_value
  }
}

output "filter_names" {
  value = { for k, v in aws_cloudwatch_log_metric_filter.filters : k => v.name }
} 