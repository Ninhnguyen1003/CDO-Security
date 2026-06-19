# -----------------------------------------------------------
# EventBridge Rule – capture all Amazon Macie findings
# -----------------------------------------------------------
resource "aws_cloudwatch_event_rule" "macie_rule" {
  name        = "macie-findings-rule"
  description = "Capture Macie Finding events and forward to SNS for email alerts"

  event_pattern = jsonencode({
    "source"      = ["aws.macie"],
    "detail-type" = ["Macie Finding"]
  })

  tags = {
    Project = "CDO-Security-Macie-Lab"
  }
}

# -----------------------------------------------------------
# EventBridge Target – send matched events to SNS Topic
# -----------------------------------------------------------
resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.macie_rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.macie_alerts.arn
}
