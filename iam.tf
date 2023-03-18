resource "aws_iam_role" "codepipeline" {
  name = "codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
  role       = aws_iam_role.codepipeline_role.name
}

data "aws_iam_policy_document" "codepipeline_role_assume_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name = "example_codepipeline_role"

  assume_role_policy = data.aws_iam_policy_document.codepipeline_role_assume_policy_doc.json
}

resource "aws_iam_policy" "codepipeline_role_policy" {
  name = "example_codepipeline_role_policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "deltacloud:*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "codepipeline_role_policy_attachment" {
  policy_arn = aws_iam_policy.codepipeline_role_policy.arn
  role       = aws_iam_role.codepipeline_role.name
}


resource "aws_iam_policy_attachment" "codebuild" {
  name       = "example_codebuild_policy_attachment"
  policy_arn = aws_iam_policy.codebuild.arn
  entities = [
    aws_iam_role.codebuild.arn
  ]
}

resource "aws_iam_policy" "codebuild" {
  name        = "example_codebuild_policy"
  description = "Policy for the example CodeBuild project"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.example.arn}",
          "${aws_s3_bucket.example.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "codebuild" {
  name               = "example_codebuild_role"
  assume_role_policy = jsonencode(data.aws_iam_policy_document.codebuild.json)

  tags = var.default_tags
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}
