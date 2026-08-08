data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "asset_processor" {
  name = "bedrock-asset-processor-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Project = "tinyuka-2025-capstone"
  }
}

data "aws_iam_policy_document" "asset_processor" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.assets.arn}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:us-east-1:*:*"]
  }
}

resource "aws_iam_role_policy" "asset_processor" {
  name   = "bedrock-asset-processor-policy"
  role   = aws_iam_role.asset_processor.id
  policy = data.aws_iam_policy_document.asset_processor.json
}

resource "aws_lambda_function" "asset_processor" {
  function_name = "bedrock-asset-processor"
  role          = aws_iam_role.asset_processor.arn

  runtime = "python3.12"
  handler = "asset_processor.lambda_handler"

  filename         = "${path.module}/lambda/asset_processor.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/asset_processor.zip")

  tags = {
    Project = "tinyuka-2025-capstone"
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets.arn
}

resource "aws_s3_bucket_notification" "assets" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}

resource "aws_cloudwatch_log_group" "asset_processor" {
  name              = "/aws/lambda/bedrock-asset-processor"
  retention_in_days = 7

  tags = {
    Project = "tinyuka-2025-capstone"
  }
}
