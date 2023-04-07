provider "aws" {
  region = "us-west-2" # 使用するリージョンを選択
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "your-bucket-name" # バケット名を指定してください
}

resource "aws_ses_identity_verification" "sender" {
  email = "your_verified_email@example.com" # 送信元メールアドレスを指定してください
}

resource "aws_ses_identity_verification" "recipient" {
  email = "recipient@example.com" # 送信先メールアドレスを指定してください
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "send_email_on_s3_upload"
  runtime       = "python3.8"

  role = aws_iam_role.lambda_role.arn

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  handler = "lambda_function.lambda_handler"

  environment {
    variables = {
      SENDER_EMAIL    = "your_verified_email@example.com"
      RECIPIENT_EMAIL = "recipient@example.com"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "send_email_on_s3_upload_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_read_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "ses_full_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  bucket = aws_s3_bucket.s3_bucket.id

  lambda_function_configuration {
    lambda_function_arn = aws_lambda_function.lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.s3_bucket.arn}/*"
}
