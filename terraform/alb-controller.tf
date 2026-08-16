data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "alb_controller" {
  name = "${local.project_name}-alb-controller-role"

  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-alb-controller-role"
    }
  )
}

resource "aws_iam_policy" "alb_controller" {
  name = "${local.project_name}-alb-controller-policy"

  policy = file("${path.module}/alb-iam-policy.json")

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = module.eks.cluster_name
  addon_name   = "eks-pod-identity-agent"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    module.eks
  ]
}

resource "aws_eks_pod_identity_association" "alb_controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.alb_controller.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent,
    aws_iam_role_policy_attachment.alb_controller
  ]
}
