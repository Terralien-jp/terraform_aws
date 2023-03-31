resource "aws_cloudwatch_event_rule" "guardduty_events_rule" {
  name        = "guardduty-events-rule"
  description = "Event rule for GuardDuty events"
  event_pattern = jsonencode({
    "detail-type": ["GuardDuty Finding"],
    detail: {
      severity:["7", "8", "9", "10"] # ???
    },
    source: ["aws.guardduty"]
  })
}

resource "aws_cloudwatch_event_target" "guardduty_events_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_events_rule.name
  target_id = "GuardDutySNSTarget"
  arn       = aws_sns_topic.guardduty_notifications.arn
}
