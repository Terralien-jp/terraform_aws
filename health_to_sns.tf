# SNS topic の作成
resource "aws_sns_topic" "aws_health_notifications" {
  name = "aws-health-notifications"
}

# SNS topic のサブスクリプションを作成
resource "aws_sns_topic_subscription" "aws_health_notifications_subscription" {
  topic_arn = aws_sns_topic.aws_health_notifications.arn
  protocol  = "email"
  endpoint  = "youremail@example.com" # 自身のメールアドレスを設定してください
}

# AWS Health EventのためのCloudWatch Eventsルールを作成
resource "aws_cloudwatch_event_rule" "aws_health_event" {
  name        = "aws-health-event"
  description = "Capture all AWS Health Events"

  event_pattern = <<PATTERN
{
  "source": ["aws.health"]
}
PATTERN
}

# SNS Topicへの通知をトリガーするようにルールを設定
resource "aws_cloudwatch_event_target" "aws_health_event_target" {
  rule      = aws_cloudwatch_event_rule.aws_health_event.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.aws_health_notifications.arn
}
