# AWS Service Monitoring with EventBridge and CloudWatch

This Terraform project creates a comprehensive AWS monitoring and alerting system using EventBridge and CloudWatch. It provides centralized monitoring, logging, and alerting for various AWS services with a focus on security and operational visibility.

## Quick Start

### Prerequisites
- AWS CLI installed and configured
- Terraform installed
- AWS credentials with appropriate permissions

### Deployment

1. **Using the Deployment Script (Recommended)**:
   ```bash
   # Make the script executable
   chmod +x deploy.sh
   
   # Run the deployment script
   ./deploy.sh
   ```

   The script will:
   - Check for required tools (AWS CLI, Terraform)
   - Verify AWS credentials
   - Initialize Terraform
   - Create and show the execution plan
   - Ask for confirmation before applying changes
   - Display the CloudWatch Dashboard URL after successful deployment

2. **Manual Deployment**:
   ```bash
   # Initialize Terraform
   terraform init
   
   # Review the plan
   terraform plan
   
   # Apply the configuration
   terraform apply
   ```

## Features

### 1. Event Monitoring
- **EC2 Monitoring**: Track instance lifecycle events (start, stop, terminate)
- **RDS Monitoring**: Monitor database operations (create, modify, delete)
- **IAM Monitoring**: Track user and policy changes
- **S3 Monitoring**: Monitor bucket operations and policy changes
- **CloudTrail Integration**: Capture all API calls
- **Security Hub Integration**: Monitor security findings
- **GuardDuty Integration**: Detect potential threats

### 2. Security Monitoring
- High severity findings tracking
- Unauthorized access detection
- Security event correlation
- Threat detection and alerting

### 3. Log Management
- Centralized CloudWatch log group
- Configurable retention period
- Optional KMS encryption
- Structured log format

### 4. Metric Analysis
- Custom metric filters
- High severity findings tracking
- Unauthorized access patterns
- Event distribution analysis

### 5. Alerting System
- Configurable alarm thresholds
- Multiple alert conditions
- Flexible evaluation periods
- Missing data handling

### 6. CloudWatch Dashboard
The project includes a comprehensive CloudWatch dashboard with the following widgets:

1. **Security Overview**
   - High severity findings trend
   - Unauthorized access attempts
   - Real-time security metrics

2. **Event Distribution**
   - Event source breakdown
   - Service-wise event count
   - Time-based distribution

3. **Recent Security Events**
   - Latest high severity findings
   - Recent unauthorized access attempts
   - Security event timeline

4. **API Call Patterns**
   - Top API calls by count
   - Service-wise API distribution
   - Access pattern analysis

5. **Custom Metrics**
   - High severity findings count
   - Unauthorized access attempts
   - Custom metric trends

## Project Structure

```
.
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Root module variables
├── outputs.tf             # Output definitions
├── modules/
│   ├── cloudwatch/        # CloudWatch logs module
│   │   └── main.tf
│   ├── eventbridge/       # EventBridge rules module
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── metric_filters/    # Metric filters module
│   │   ├── main.tf
│   │   └── variables.tf
│   └── alarms/           # CloudWatch alarms module
│       ├── main.tf
│       └── variables.tf
└── README.md              # This documentation
```

## Usage

1. Configure your AWS credentials
2. Update variables in `variables.tf`:
   ```hcl
   variable "aws_region" {
     description = "AWS region to deploy resources"
     type        = string
     default     = "us-east-1"
   }

   variable "environment" {
     description = "Environment name (e.g., dev, prod)"
     type        = string
     default     = "dev"
   }

   variable "project_name" {
     description = "Name of the project"
     type        = string
     default     = "aws-service-monitoring"
   }

   variable "kms_key_arn" {
     description = "ARN of the KMS key for CloudWatch log encryption"
     type        = string
     default     = null
   }
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the plan:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Monitoring Events

### EC2 Events
- `RunInstances`
- `StopInstances`
- `TerminateInstances`
- `ModifyInstanceAttribute`
- `CreateSecurityGroup`
- `DeleteSecurityGroup`

### RDS Events
- `CreateDBInstance`
- `DeleteDBInstance`
- `ModifyDBInstance`
- `CreateDBSnapshot`
- `DeleteDBSnapshot`

### IAM Events
- `CreateUser`
- `DeleteUser`
- `CreatePolicy`
- `DeletePolicy`
- `AttachUserPolicy`
- `DetachUserPolicy`
- `CreateAccessKey`
- `DeleteAccessKey`

### S3 Events
- `CreateBucket`
- `DeleteBucket`
- `PutBucketPolicy`
- `PutBucketAcl`
- `PutBucketEncryption`

### CloudTrail Events
- `LookupEvents`
- `CreateTrail`
- `UpdateTrail`
- `DeleteTrail`

## Security Monitoring

### Security Hub Findings
- High severity findings
- Critical severity findings
- Compliance issues

### GuardDuty Findings
- High severity threats (numeric severity 7-10)
- Suspicious activities
- Threat intelligence

## Alerting Configuration

### High Severity Findings Alert
- Metric: `HighSeverityFindings`
- Threshold: 1
- Evaluation Periods: 1
- Period: 300 seconds

### Unauthorized API Calls Alert
- Metric: `UnauthorizedAPICalls`
- Threshold: 5
- Evaluation Periods: 1
- Period: 300 seconds

## Security Considerations

1. **Log Encryption**
   - Optional KMS encryption for CloudWatch logs
   - Configurable KMS key ARN

2. **Access Control**
   - Proper IAM permissions required
   - Least privilege principle

3. **Data Retention**
   - Configurable log retention period
   - Default: 30 days

4. **Resource Tagging**
   - Environment tags
   - Project tags
   - Custom tags support

## Outputs

```hcl
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

output "dashboard_url" {
  value = "https://console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${var.name}"
}
```

## Best Practices

1. **Environment Separation**
   - Use different configurations for dev/prod
   - Separate log groups per environment

2. **Monitoring Customization**
   - Adjust event patterns as needed
   - Modify alert thresholds based on requirements

3. **Security Hardening**
   - Enable KMS encryption for sensitive logs
   - Review and adjust IAM permissions

4. **Cost Optimization**
   - Adjust retention periods based on needs
   - Monitor and optimize metric filters

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Viewing Event Bus Events in CloudWatch

### Purpose
This project enables you to monitor and view all events passing through the default Event Bus by capturing them in CloudWatch Logs. This provides a centralized location to analyze and track all AWS service events.

### How to View Events

1. **Access CloudWatch Logs**:
   ```bash
   # 1. Go to AWS CloudWatch Console
   # 2. Click on "Log groups"
   # 3. Look for the log group: "/aws/events/service-monitoring"
   # 4. Click on it to view all captured events
   ```

2. **Event Details Available**:
   - Event source (e.g., aws.ec2, aws.s3)
   - Event timestamp
   - Detailed event information in JSON format
   - Event type and category
   - Affected resources
   - User/role that triggered the event

3. **Search and Analysis**:
   - Use CloudWatch Logs Insights for advanced queries
   - Filter events by time range
   - Search by event type or source
   - Create custom queries for specific patterns

4. **Example CloudWatch Logs Insights Queries**:
   ```sql
   # View all EC2 events
   filter @message like /aws.ec2/
   
   # View high severity security findings
   filter @message like /HIGH/ or @message like /CRITICAL/
   
   # View unauthorized access attempts
   filter @message like /AccessDenied/
   
   # View specific event types
   filter eventName = 'RunInstances' or eventName = 'StopInstances'
   ```

5. **Event Categories Captured**:
   - EC2 instance lifecycle events
   - RDS database operations
   - IAM user and policy changes
   - S3 bucket operations
   - CloudTrail API calls
   - Security Hub findings
   - GuardDuty threat detections

6. **Benefits of This Approach**:
   - Centralized event logging
   - Historical event tracking
   - Advanced search capabilities
   - Integration with other AWS services
   - Compliance and audit trail 