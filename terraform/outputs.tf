output "vpc_id" {
  description = "ID of the Project Bedrock VPC."
  value       = module.vpc.vpc_id
}
output "eks_cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS Kubernetes version."
  value       = module.eks.cluster_version
}

output "eks_node_group_name" {
  description = "EKS managed node group name."
  value       = module.eks.node_group_name
}
output "catalog_rds_endpoint" {
  description = "MySQL endpoint for the Catalog service."
  value       = aws_db_instance.catalog_mysql.address
}

output "orders_rds_endpoint" {
  description = "PostgreSQL endpoint for the Orders service."
  value       = aws_db_instance.orders_postgres.address
}

output "carts_table_name" {
  description = "DynamoDB table used by the Carts service."
  value       = aws_dynamodb_table.carts.name
}
