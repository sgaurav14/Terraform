output "bucket_name" {
    description = "The name of s3 bucket"
    value = aws_s3_bucket.my_bucket.id
}