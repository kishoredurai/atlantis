provider "aws" {
    region = "us-east-1"

}


resource "aws_s3_bucket" "kishore_bucket" {
  bucket = var.bucket_name

  tags = {
   Description = "Testing code"
  }
}


resource "aws_s3_object" "finance_data" {
  bucket = aws_s3_bucket.kishore_bucket.id
  key = "test.doc"
  content = "./test.doc"

}

data "aws_iam_group" "kishore_group" {
  group_name = "kishore_admin_users"
}



resource "aws_s3_bucket_policy" "kishore-bucket_policy" {
  bucket = aws_s3_bucket.kishore_bucket.id


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        
        Effect    = "Allow"
        Action    = "s3:*"
        Resource = "arn:aws:s3:::${aws_s3_bucket.kishore_bucket.id}"
        Principal = {
            AWS = ["${data.aws_iam_group.kishore_group.arn}"]
            
        }
      },
    ]
  })
}