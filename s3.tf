resource "aws_s3_bucket" "artifact" {
  bucket = "${local.app_name}-${local.environment}-artifact-bucket"
}
