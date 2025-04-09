output "rule_arns" {
  description = "Map of rule names to their ARNs"
  value       = { for k, v in aws_cloudwatch_event_rule.this : k => v.arn }
}

output "rule_names" {
  description = "Map of rule names to their names (useful for dependencies)"
  value       = { for k, v in aws_cloudwatch_event_rule.this : k => v.name }
}

output "target_arns" {
  description = "Map of rule names to their target ARNs"
  value       = { for k, v in aws_cloudwatch_event_target.this : k => v.arn }
} 