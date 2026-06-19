output "s3_bucket_name" {
  value       = aws_s3_bucket.sensitive_data.bucket
  description = "Name of the S3 bucket scanned by Macie"
}

output "sns_topic_arn" {
  value       = aws_sns_topic.macie_alerts.arn
  description = "ARN of the SNS topic for email alerts"
}

output "macie_job_id" {
  value       = aws_macie2_classification_job.scan_job.id
  description = "ID of the Macie classification job"
}

output "eventbridge_rule_arn" {
  value       = aws_cloudwatch_event_rule.macie_rule.arn
  description = "ARN of the EventBridge rule for Macie findings"
}
