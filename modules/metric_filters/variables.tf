variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "metric_namespace" {
  description = "Namespace for the CloudWatch metrics"
  type        = string
  default     = "Custom/ServiceMonitoring"
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