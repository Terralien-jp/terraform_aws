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

resource "aws_cloudwatch_event_target" "example" {
  rule      = aws_cloudwatch_event_rule.example.name
  target_id = "example-target-id"
  arn       = aws_lambda_function.example.arn

  input_transformer {
    input_paths = {
      instance = "$.detail.instance"
      state    = "$.detail.state"
    }

    input_template = <<EOT
{
  "instance": <instance>,
  "state": <state>,
  "timestamp": "${timestamp()}"
}
EOT
  }
}
