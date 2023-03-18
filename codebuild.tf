resource "aws_codebuild_project" "example" {
  name          = "example"
  description   = "Example CodeBuild project"
  service_role  = aws_iam_role.codebuild.arn
  artifacts     = { type = "NO_ARTIFACTS" }

  source {
    type      = "GITHUB"
    location  = "https://github.com/example/example.git"
    buildspec = "buildspec.yml"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
  }

  encryption_key = aws_kms_key.build.id
}
