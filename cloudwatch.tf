resource "aws_cloudwatch_log_metric_filter" "example" {
  name           = "example-filter"
  pattern        = "ERROR"
  log_group_name = "your-log-group-name"  # 監視するロググループの名前を指定してください

  metric_transformation {
    name      = "ExampleMetric"
    namespace = "Custom/Logs"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "example" {
  alarm_name          = "example-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ExampleMetric"
  namespace           = "Custom/Logs"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"

  alarm_description = "Log error alarm"
  alarm_actions     = ["arn:aws:sns:us-east-1:123456789012:example-topic"]  # 通知を受け取るSNSトピックのARNを指定してください
}
