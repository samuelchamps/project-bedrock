# Project Bedrock – InnovateMart EKS Deployment

## Overview

Project Bedrock is a production-oriented Amazon EKS deployment for InnovateMart's Retail Store microservices application.

The infrastructure is provisioned with Terraform in AWS Region `us-east-1`. The application runs in the `retail-app` Kubernetes namespace and uses managed AWS services for its persistent data layer.

## Project Standards

| Requirement | Configuration |
|---|---|
| AWS Region | `us-east-1` |
| EKS Cluster | `project-bedrock-cluster` |
| VPC | `project-bedrock-vpc` |
| Kubernetes Namespace | `retail-app` |
| Developer IAM User | `bedrock-dev-view` |
| S3 Assets Bucket | `bedrock-assets-alt-soe-tin-025-0048` |
| Lambda Function | `bedrock-asset-processor` |
| Project Tag | `Project: tinyuka-2025-capstone` |

---

## Architecture

The solution consists of:

- Amazon VPC spanning two Availability Zones
- Public and private subnets
- Single NAT Gateway for cost control
- Amazon EKS cluster
- Two EKS worker nodes
- AWS Load Balancer Controller
- Internet-facing Application Load Balancer
- Retail Store microservices in the `retail-app` namespace
- Amazon RDS MySQL for Catalog
- Amazon RDS PostgreSQL for Orders
- Amazon DynamoDB for Carts
- RabbitMQ running inside EKS
- Amazon S3 for product assets
- AWS Lambda for S3 event processing
- Amazon CloudWatch for logging
- IAM developer access using EKS Access Entries
- Terraform remote state stored in S3 with native state locking

See the architecture diagram included with the project documentation.

---

## Infrastructure as Code

Terraform is used to provision and manage the AWS infrastructure.

The Terraform configuration is located in:

```text
terraform/
├── backend.tf
├── budget.tf
├── database.tf
├── dynamodb.tf
├── iam.tf
├── lambda.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── rds.tf
├── s3.tf
├── variables.tf
├── versions.tf
├── lambda/
└── modules/
