resource "aws_iam_role_policy" "policy_for_lambda" {
  name = "policy_for_lambda"
  role = aws_iam_role.role_for_lambda.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::${var.bucket_name}"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": ["arn:aws:s3:::${var.bucket_name}/*"]
        }
    ]
}
EOF
}

resource "aws_iam_role" "role_for_lambda" {
  name = "role_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "image_resizer_lambda" {
  function_name = "image_resizer_lambda"
  role          = aws_iam_role.role_for_lambda.arn
  handler       = "example.Handler::handleRequest"
  filename      = "s3-java/target/s3-java-1.0-SNAPSHOT.jar"
  timeout       = 60
  runtime       = "java11"
  memory_size   = 1024
  environment {
    variables = {
      ENV_MAX_WIDTH = "200",
      ENV_MAX_HEIGHT = "200"
    }
  }
}

# Create S3 bucket notification (trigger)
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_resizer_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.images_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.images_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_resizer_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "original-images/"
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.image_resizer_lambda.function_name}"
  retention_in_days = 1
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.role_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}