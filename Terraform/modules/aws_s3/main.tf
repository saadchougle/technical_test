#Create S3 
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-${var.env}-media-bucket-1" 
}

# This is required by Wordpress offload plugin
resource "aws_s3_bucket_public_access_block" "media_bucket_public_access" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}