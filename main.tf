terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# CloudWatch Log Group Module
module "cloudwatch_logs" {
  source = "./modules/cloudwatch"
  
  name              = "/aws/events/service-monitoring"
  retention_in_days = 30
  kms_key_id        = var.kms_key_arn
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# EventBridge Rules Module
module "eventbridge_rules" {
  source = "./modules/eventbridge"
  
  project_name              = var.project_name
  environment              = var.environment
  cloudwatch_log_group_arn = module.cloudwatch_logs.arn
  
  # EC2 Events
  ec2_events_enabled = true
  ec2_event_pattern = {
    source      = ["aws.ec2"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["ec2.amazonaws.com"]
      eventName   = ["RunInstances", "StopInstances", "TerminateInstances", "ModifyInstanceAttribute", "CreateSecurityGroup", "DeleteSecurityGroup"]
    }
  }

  # RDS Events
  rds_events_enabled = true
  rds_event_pattern = {
    source      = ["aws.rds"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["rds.amazonaws.com"]
      eventName   = ["CreateDBInstance", "DeleteDBInstance", "ModifyDBInstance", "CreateDBSnapshot", "DeleteDBSnapshot"]
    }
  }

  # IAM Events
  iam_events_enabled = true
  iam_event_pattern = {
    source      = ["aws.iam"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["iam.amazonaws.com"]
      eventName   = ["CreateUser", "DeleteUser", "CreatePolicy", "DeletePolicy", "AttachUserPolicy", "DetachUserPolicy", "CreateAccessKey", "DeleteAccessKey"]
    }
  }

  # S3 Events
  s3_events_enabled = true
  s3_event_pattern = {
    source      = ["aws.s3"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["s3.amazonaws.com"]
      eventName   = ["CreateBucket", "DeleteBucket", "PutBucketPolicy", "PutBucketAcl", "PutBucketEncryption"]
    }
  }

  # CloudTrail Events
  cloudtrail_events_enabled = true
  cloudtrail_event_pattern = {
    source      = ["aws.cloudtrail"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["cloudtrail.amazonaws.com"]
      eventName   = ["LookupEvents", "CreateTrail", "UpdateTrail", "DeleteTrail"]
    }
  }

  # Security Hub Events
  security_hub_events_enabled = true
  security_hub_event_pattern = {
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        Severity = {
          Label = ["HIGH", "CRITICAL"]
        }
      }
    }
  }

  # GuardDuty Events
  guardduty_events_enabled = true
  guardduty_event_pattern = {
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
    detail = {
      severity = {
        numeric = [7, 8, 9, 10]  # High and Critical severity findings
      }
    }
  }
}

# CloudWatch Metric Filters
module "metric_filters" {
  source = "./modules/metric_filters"
  
  log_group_name = module.cloudwatch_logs.name
  metric_namespace = "Custom/ServiceMonitoring"
  
  filters = {
    "HighSeverityFindings" = {
      pattern        = "{ $.detail.findings[?(@.Severity.Label == 'HIGH' || @.Severity.Label == 'CRITICAL')] }"
      metric_name    = "HighSeverityFindings"
      metric_value   = "1"
      default_value  = "0"
    }
    "UnauthorizedAPICalls" = {
      pattern        = "{ $.detail.errorCode = 'AccessDenied' }"
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
    "HighSeverityFindings" = {
      metric_name         = "HighSeverityFindings"
      threshold           = 1
      evaluation_periods  = 1
      period             = 300
      comparison_operator = "GreaterThanOrEqualToThreshold"
      alarm_description   = "Alarm when high severity findings are detected"
    }
    "UnauthorizedAPICalls" = {
      metric_name         = "UnauthorizedAPICalls"
      threshold           = 5
      evaluation_periods  = 1
      period             = 300
      comparison_operator = "GreaterThanOrEqualToThreshold"
      alarm_description   = "Alarm when multiple unauthorized API calls are detected"
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