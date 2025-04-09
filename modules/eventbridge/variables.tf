variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  type        = string
}

# EC2 Events Variables
variable "ec2_events_enabled" {
  description = "Whether to enable EC2 event monitoring"
  type        = bool
  default     = false
}

variable "ec2_event_pattern" {
  description = "Event pattern for EC2 events"
  type        = any
  default     = {}
}

# RDS Events Variables
variable "rds_events_enabled" {
  description = "Whether to enable RDS event monitoring"
  type        = bool
  default     = false
}

variable "rds_event_pattern" {
  description = "Event pattern for RDS events"
  type        = any
  default     = {}
}

# IAM Events Variables
variable "iam_events_enabled" {
  description = "Whether to enable IAM event monitoring"
  type        = bool
  default     = false
}

variable "iam_event_pattern" {
  description = "Event pattern for IAM events"
  type        = any
  default     = {}
}

# S3 Events Variables
variable "s3_events_enabled" {
  description = "Whether to enable S3 event monitoring"
  type        = bool
  default     = false
}

variable "s3_event_pattern" {
  description = "Event pattern for S3 events"
  type        = any
  default     = {}
}

# CloudTrail Events Variables
variable "cloudtrail_events_enabled" {
  description = "Whether to enable CloudTrail event monitoring"
  type        = bool
  default     = false
}

variable "cloudtrail_event_pattern" {
  description = "Event pattern for CloudTrail events"
  type        = any
  default     = {}
}

# Security Hub Events Variables
variable "security_hub_events_enabled" {
  description = "Whether to enable Security Hub event monitoring"
  type        = bool
  default     = false
}

variable "security_hub_event_pattern" {
  description = "Event pattern for Security Hub events"
  type        = any
  default     = {}
}

# GuardDuty Events Variables
variable "guardduty_events_enabled" {
  description = "Whether to enable GuardDuty event monitoring"
  type        = bool
  default     = false
}

variable "guardduty_event_pattern" {
  description = "Event pattern for GuardDuty events"
  type        = any
  default     = {}
} 