terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# CloudWatch Log Group Module
module "cloudwatch_logs" {
  source = "./modules/cloudwatch"
  
  name              = "/aws/events/service-monitoring"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id
  tags              = var.tags
}

# EventBridge Rules Module
module "eventbridge_rules" {
  source = "./modules/eventbridge"
  
  project_name = var.name
  environment  = var.environment
  
  event_rules = {
    ec2 = {
      name           = "${var.name}-ec2-events-${var.environment}"
      description    = "Capture EC2 instance state changes"
      event_pattern  = jsonencode({
        source      = ["aws.ec2"]
        detail-type = ["AWS API Call via CloudTrail"]
        detail = {
          eventSource = ["ec2.amazonaws.com"]
          eventName   = ["RunInstances", "StopInstances", "TerminateInstances"]
        }
      })
      event_bus_name = null
      tags          = var.tags
    },
    rds = {
      name           = "${var.name}-rds-events-${var.environment}"
      description    = "Capture RDS instance changes"
      event_pattern  = jsonencode({
        source      = ["aws.rds"]
        detail-type = ["AWS API Call via CloudTrail"]
        detail = {
          eventSource = ["rds.amazonaws.com"]
          eventName   = ["CreateDBInstance", "DeleteDBInstance", "ModifyDBInstance"]
        }
      })
      event_bus_name = null
      tags          = var.tags
    },
    iam = {
      name           = "${var.name}-iam-events-${var.environment}"
      description    = "Capture IAM changes"
      event_pattern  = jsonencode({
        source      = ["aws.iam"]
        detail-type = ["AWS API Call via CloudTrail"]
        detail = {
          eventSource = ["iam.amazonaws.com"]
          eventName   = ["CreateUser", "DeleteUser", "CreatePolicy", "DeletePolicy"]
        }
      })
      event_bus_name = null
      tags          = var.tags
    },
    s3 = {
      name           = "${var.name}-s3-events-${var.environment}"
      description    = "Capture S3 bucket changes"
      event_pattern  = jsonencode({
        source      = ["aws.s3"]
        detail-type = ["AWS API Call via CloudTrail"]
        detail = {
          eventSource = ["s3.amazonaws.com"]
          eventName   = ["CreateBucket", "DeleteBucket", "PutBucketPolicy"]
        }
      })
      event_bus_name = null
      tags          = var.tags
    },
    cloudtrail = {
      name           = "${var.name}-cloudtrail-events-${var.environment}"
      description    = "Capture CloudTrail events"
      event_pattern  = jsonencode({
        source      = ["aws.cloudtrail"]
        detail-type = ["AWS API Call via CloudTrail"]
      })
      event_bus_name = null
      tags          = var.tags
    },
    security_hub = {
      name           = "${var.name}-security-hub-events-${var.environment}"
      description    = "Capture Security Hub findings"
      event_pattern  = jsonencode({
        source      = ["aws.securityhub"]
        detail-type = ["Security Hub Findings - Imported"]
      })
      event_bus_name = null
      tags          = var.tags
    },
    guardduty = {
      name           = "${var.name}-guardduty-events-${var.environment}"
      description    = "Capture GuardDuty findings"
      event_pattern  = jsonencode({
        source      = ["aws.guardduty"]
        detail-type = ["GuardDuty Finding"]
      })
      event_bus_name = null
      tags          = var.tags
    }
  }
  
  cloudwatch_log_group_arn = module.cloudwatch_logs.arn
  tags                     = var.tags
}

# CloudWatch Metric Filters
module "metric_filters" {
  source = "./modules/metrics"
  
  name           = var.name
  log_group_name = module.cloudwatch_logs.name
  
  filters = {
    high_severity = {
      pattern        = "{ ($.detail.findings.Severity.Label = \"HIGH\") || ($.detail.findings.Severity.Label = \"CRITICAL\") }"
      metric_name    = "HighSeverityFindings"
      metric_value   = "1"
      default_value  = "0"
    }
    unauthorized_access = {
      pattern        = "{ $.detail.errorCode = \"AccessDenied\" }"
      metric_name    = "UnauthorizedAPICalls"
      metric_value   = "1"
      default_value  = "0"
    }
  }
}

# CloudWatch Alarms
module "alarms" {
  source = "./modules/alarms"
  
  metric_namespace = "Custom/ServiceMonitoring"
  
  alarms = {
    high_severity = {
      metric_name         = "HighSeverityFindings"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "1"
      metric_period       = "300"
      threshold           = "0"
      statistic           = "Sum"
      treat_missing_data  = "notBreaching"
    }
    unauthorized_access = {
      metric_name         = "UnauthorizedAPICalls"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = "1"
      metric_period       = "300"
      threshold           = "0"
      statistic           = "Sum"
      treat_missing_data  = "notBreaching"
    }
  }
}

# Outputs
output "eventbridge_rules" {
  value = module.eventbridge_rules.rule_arns
}

output "cloudwatch_log_group" {
  value = module.cloudwatch_logs.arn
}

output "metric_filters" {
  value = module.metric_filters.filter_names
}

output "alarms" {
  value = module.alarms.alarm_arns
}

module "dashboard" {
  source = "./modules/dashboard"

  name = var.name
}

output "dashboard_url" {
  value = "https://console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${var.name}"
} 