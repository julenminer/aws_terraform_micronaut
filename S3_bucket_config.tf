resource "aws_s3_bucket" "images_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_object" "original_images_folder" {
  bucket = aws_s3_bucket.images_bucket.id
  key    = "original-images/"
}

resource "aws_s3_bucket_object" "images_folder" {
  bucket = aws_s3_bucket.images_bucket.id
  key    = "images/"
}