# modules/storage/main.tf
variable "bucket_name" { type = string }

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"
}
