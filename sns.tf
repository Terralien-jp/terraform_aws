resource "aws_sns_topic" "my_sns_topic" {
  name = "my-sns-topic"
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = data.aws_sns_topic.my_sns_topic.arn
  protocol  = "lambda"
  endpoint  = data.aws_lambda_function.my_lambda_function.arn
}