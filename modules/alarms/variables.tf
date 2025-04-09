variable "metric_namespace" {
  description = "Namespace for the metrics"
  type        = string
}

variable "alarms" {
  description = "Map of alarms to create"
  type = map(object({
    metric_name         = string
    comparison_operator = string
    evaluation_periods  = string
    metric_period       = string
    threshold           = string
    statistic           = string
    treat_missing_data  = string
  }))
}

variable "alarm_actions" {
  description = "List of ARNs to notify when alarm is triggered"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "List of ARNs to notify when alarm is resolved"
  type        = list(string)
  default     = []
} 