resource "aws_lambda_function" "guardduty_notification_lambda" {
  filename      = "guardduty_notification.zip"
  function_name = "guardduty_notification_lambda"
  role          = aws_iam_role.guardduty_notification_lambda.arn
  handler       = "index.handler"
  runtime       = "python3.8"

  environment {
    variables = {
      TEAMS_WEBHOOK_URL = var.teams_webhook_url
    }
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "lambda"
  output_path = "guardduty_notification.zip"
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.guardduty_notification_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.guardduty_topic.arn
}

locals {
  lambda_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role" "guardduty_notification_lambda" {
  name = "guardduty_notification_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "guardduty_notification_lambda" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.guardduty_notification_lambda.name
}

resource "aws_iam_policy" "lambda_logs" {
  name        = "lambda_logs"
  description = "Policy for logging from lambda functions"

  policy = local.lambda_role_policy
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  policy_arn = aws_iam_policy.lambda_logs.arn
  role       = aws_iam_role.guardduty_notification_lambda.name
}

