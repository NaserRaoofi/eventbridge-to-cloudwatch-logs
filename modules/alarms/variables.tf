variable "metric_namespace" {
  description = "Namespace for the CloudWatch metrics"
  type        = string
}

variable "alarms" {
  description = "Map of CloudWatch alarms to create"
  type = map(object({
    metric_name         = string
    threshold           = number
    evaluation_periods  = number
    period             = number
    comparison_operator = string
    alarm_description   = string
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