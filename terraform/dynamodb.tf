resource "aws_dynamodb_table" "carts" {
  name         = "${local.project_name}-carts"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "customerId"
    type = "S"
  }

  global_secondary_index {
    name            = "idx_global_customerId"
    hash_key        = "customerId"
    projection_type = "ALL"
  }

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.project_name}-carts"
      Service = "carts"
    }
  )
}

data "aws_iam_policy_document" "carts_pod_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "carts" {
  name               = "${local.project_name}-carts-role"
  assume_role_policy = data.aws_iam_policy_document.carts_pod_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.project_name}-carts-role"
      Service = "carts"
    }
  )
}

resource "aws_iam_role_policy" "carts_dynamodb" {
  name = "${local.project_name}-carts-dynamodb"
  role = aws_iam_role.carts.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.carts.arn,
          "${aws_dynamodb_table.carts.arn}/index/*"
        ]
      }
    ]
  })
}

resource "aws_eks_pod_identity_association" "carts" {
  cluster_name    = module.eks.cluster_name
  namespace       = "retail-app"
  service_account = "carts"
  role_arn        = aws_iam_role.carts.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
}
