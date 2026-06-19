# -----------------------------------------------------------
# SNS Topic – receives Macie findings from EventBridge
# -----------------------------------------------------------
resource "aws_sns_topic" "macie_alerts" {
  name = "macie-findings-alerts-topic"

  tags = {
    Project = "CDO-Security-Macie-Lab"
  }
}

# -----------------------------------------------------------
# SNS Email Subscription – sends alerts to your inbox
# After `terraform apply`, check your email and click
# "Confirm Subscription" to activate notifications.
# -----------------------------------------------------------
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.macie_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# -----------------------------------------------------------
# SNS Topic Policy – allow EventBridge to publish messages
# -----------------------------------------------------------
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "AllowEventBridgePublish"
    effect = "Allow"

    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.macie_alerts.arn]
  }
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.macie_alerts.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
