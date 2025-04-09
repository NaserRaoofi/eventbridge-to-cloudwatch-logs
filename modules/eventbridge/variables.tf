variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch Log Group where events will be sent"
  type        = string
}

variable "event_rules" {
  description = "Map of event rule configurations"
  type = map(object({
    name           = string
    description    = string
    event_pattern  = string
    event_bus_name = optional(string)
    tags          = optional(map(string))
  }))
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 