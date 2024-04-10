resource "aws_s3_bucket" "this" {
  bucket        = var.name_bucket
  force_destroy = var.force_destroy

  tags = merge(
    {
      "Name"        = format("%s-%s", var.name_bucket, var.environment)
      "Platform"    = "Storage"
      "Type"        = "S3"
      "Environment" = var.environment
    },
    var.tags,
  )
}