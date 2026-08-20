resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"

  tags = {
    Project = "tinyuka-2025-capstone"
  }
}

resource "aws_iam_user_policy_attachment" "bedrock_dev_readonly" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy" "bedrock_dev_s3_upload" {
  name = "bedrock-dev-s3-upload"
  user = aws_iam_user.bedrock_dev_view.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowUploadToAssetsBucket"
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.assets.arn}/*"
      }
    ]
  })
}

resource "aws_eks_access_entry" "bedrock_dev_view" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_user.bedrock_dev_view.arn
  type          = "STANDARD"

  tags = {
    Project = "tinyuka-2025-capstone"
  }
}

resource "aws_eks_access_policy_association" "bedrock_dev_view" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.bedrock_dev_view.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  access_scope {
    type       = "namespace"
    namespaces = ["retail-app"]
  }

  depends_on = [
    aws_eks_access_entry.bedrock_dev_view
  ]
}
