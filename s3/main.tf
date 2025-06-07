resource "aws_s3_bucket" "my_bucket" {
        bucket = var.s3_bucket_name

        tags = {
            Name = var.s3_bucket_name
            Environment = "dev"
        }
}


resource "aws_s3_bucket_versioning" "Versioning" {
        bucket = aws_s3_bucket.my_bucket.id
        versioning_configuration {
          status = "Enabled"
        }
}


