resource "aws_kms_key" "build" {
  description             = "KMS key to encrypt data"
  deletion_window_in_days = 10
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*",
        ],
        Effect : "Allow",
        Principle : "*",
        Resource : "*"
      }
    ]
  })
}
