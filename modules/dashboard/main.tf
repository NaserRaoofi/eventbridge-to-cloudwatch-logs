variable "name" {
  description = "Name of the dashboard"
  type        = string
}

variable "metrics" {
  description = "List of metric names to display"
  type        = list(string)
  default     = ["HighSeverityFindings", "UnauthorizedAPICalls"]
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.name
  dashboard_body = jsonencode({
    widgets = [
      # Security Overview Widget
      {
        type   = "metric"
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["Custom/ServiceMonitoring", "HighSeverityFindings", "RuleName", var.name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = "eu-west-2"
          title   = "High Severity Security Findings"
          period  = 300
        }
      },
      # Unauthorized Access Widget
      {
        type   = "metric"
        width  = 24
        height = 6
        properties = {
          metrics = [
            ["Custom/ServiceMonitoring", "UnauthorizedAPICalls", "RuleName", var.name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = "eu-west-2"
          title   = "Unauthorized API Calls"
          period  = 300
        }
      },
      # Event Distribution Widget
      {
        type   = "log"
        width  = 24
        height = 6
        properties = {
          query   = "SOURCE '/aws/events/service-monitoring' | stats count(*) by eventSource"
          region  = "eu-west-2"
          title   = "Event Distribution by Source"
          view    = "table"
        }
      },
      # Recent Security Events Widget
      {
        type   = "log"
        width  = 24
        height = 6
        properties = {
          query   = "SOURCE '/aws/events/service-monitoring' | filter @message like /HIGH/ or @message like /CRITICAL/ | sort @timestamp desc | limit 20"
          region  = "eu-west-2"
          title   = "Recent Security Events"
          view    = "table"
        }
      },
      # API Call Patterns Widget
      {
        type   = "log"
        width  = 24
        height = 6
        properties = {
          query   = "SOURCE '/aws/events/service-monitoring' | stats count(*) by eventName | sort count(*) desc | limit 10"
          region  = "eu-west-2"
          title   = "Top API Calls"
          view    = "table"
        }
      }
    ]
  })
} 