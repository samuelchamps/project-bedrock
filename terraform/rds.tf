resource "aws_db_subnet_group" "project_bedrock" {
  name       = "${local.project_name}-db-subnet-group"
  subnet_ids = module.vpc.private_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-db-subnet-group"
    }
  )
}

resource "aws_db_instance" "catalog_mysql" {
  identifier = "${local.project_name}-catalog-mysql"

  engine = "mysql"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "catalog"
  username = "catalogadmin"

  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.project_bedrock.name
  vpc_security_group_ids = [
    aws_security_group.rds_mysql.id
  ]

  publicly_accessible = false

  backup_retention_period = 1

  skip_final_snapshot = true
  deletion_protection = false

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.project_name}-catalog-mysql"
      Service = "catalog"
    }
  )
}

resource "aws_db_instance" "orders_postgres" {
  identifier = "${local.project_name}-orders-postgres"

  engine = "postgres"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "orders"
  username = "ordersadmin"

  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.project_bedrock.name
  vpc_security_group_ids = [
    aws_security_group.rds_postgres.id
  ]

  publicly_accessible = false

  backup_retention_period = 1

  skip_final_snapshot = true
  deletion_protection = false

  tags = merge(
    local.common_tags,
    {
      Name    = "${local.project_name}-orders-postgres"
      Service = "orders"
    }
  )
}

resource "aws_iam_role_policy" "github_actions_rds_secrets" {
  name = "project-bedrock-github-actions-rds-secrets"
  role = "ProjectBedrockGitHubActionsRole"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = [
          aws_db_instance.catalog_mysql.master_user_secret[0].secret_arn,
          aws_db_instance.orders_postgres.master_user_secret[0].secret_arn
        ]
      }
    ]
  })
}
