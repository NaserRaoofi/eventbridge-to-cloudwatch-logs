# AWS Service Monitoring with EventBridge and CloudWatch

This Terraform project sets up monitoring for various AWS services using EventBridge rules and CloudWatch Logs. It captures important events from EC2, RDS, IAM, S3, and CloudTrail services and sends them to CloudWatch Logs for centralized monitoring.

## Project Structure

```
.
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Root module variables
├── README.md              # This documentation
└── modules/
    ├── eventbridge/       # EventBridge rules module
    │   ├── main.tf
    │   └── variables.tf
    └── cloudwatch/        # CloudWatch logs module
        ├── main.tf
        └── variables.tf
```

## Features

- **EC2 Monitoring**: Tracks instance starts, stops, and terminations
- **RDS Monitoring**: Monitors database instance creation and deletion
- **IAM Monitoring**: Captures user and policy changes
- **S3 Monitoring**: Tracks bucket creation and deletion
- **CloudTrail Monitoring**: Detects suspicious API calls

## Usage

1. Configure your AWS credentials
2. Update variables in `variables.tf` as needed
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

## Variables

### Root Module Variables

- `aws_region`: AWS region to deploy resources (default: "us-east-1")
- `environment`: Environment name (e.g., dev, prod)
- `project_name`: Name of the project

### EventBridge Module Variables

- `ec2_events_enabled`: Enable/disable EC2 event monitoring
- `rds_events_enabled`: Enable/disable RDS event monitoring
- `iam_events_enabled`: Enable/disable IAM event monitoring
- `s3_events_enabled`: Enable/disable S3 event monitoring
- `cloudtrail_events_enabled`: Enable/disable CloudTrail event monitoring

### CloudWatch Module Variables

- `log_group_name`: Name of the CloudWatch log group
- `retention_days`: Number of days to retain log events (default: 30)
- `kms_key_id`: ARN of the KMS key for log encryption (optional)

## Outputs

- `eventbridge_rules`: ARNs of all created EventBridge rules
- `cloudwatch_log_group`: ARN of the CloudWatch log group

## Security Considerations

- Ensure proper IAM permissions are set up
- Consider using KMS encryption for sensitive logs
- Review and adjust retention periods based on compliance requirements

## License

This project is licensed under the MIT License - see the LICENSE file for details. 