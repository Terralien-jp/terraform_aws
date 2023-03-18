resource "aws_codecommit_repository" "this" {
  repository_name = "${local.app_name}-${local.environment}-repo"
  description     = "This is an example repo."
}
