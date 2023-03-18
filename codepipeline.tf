resource "aws_codepipeline" "this" {
  name     = "${local.app_name}-${local.environment}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.artifact.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "SourceActionName"
      category = "Source"
      owner    = "AWS"
      provider = "CodeCommit"
      version  = "1"

      configuration = {
        RepositoryName = aws_codecommit_repository.this.name
        BranchName     = "master"
      }

      output_artifacts = ["SourceOutput"]
    }
  }

  stage {
    name = "Build"

    action {
      name            = "BuildActionName"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["SourceOutput"]

      configuration = {
        ProjectName = aws_codebuild_project.example_project.name
      }

      output_artifacts = ["BuildOutput"]
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployActionName"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "EKS"
      version         = "1"
      input_artifacts = ["BuildOutput"]

      configuration = {
        ClusterName     = "example-cluster-name"
        Namespace       = "example-namespace"
        OutputAMIs      = ""
        OutputImages    = ""
        OutputVariables = ""
      }
    }
  }
}
