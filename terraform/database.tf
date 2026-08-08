resource "aws_security_group" "rds_mysql" {
  name        = "${local.project_name}-rds-mysql-sg"
  description = "Security group for Project Bedrock MySQL RDS"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = module.vpc.private_subnet_cidrs

    content {
      description = "MySQL from EKS private subnet"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-rds-mysql-sg"
    }
  )
}

resource "aws_security_group" "rds_postgres" {
  name        = "${local.project_name}-rds-postgres-sg"
  description = "Security group for Project Bedrock PostgreSQL RDS"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = module.vpc.private_subnet_cidrs

    content {
      description = "PostgreSQL from EKS private subnet"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-rds-postgres-sg"
    }
  )
}
