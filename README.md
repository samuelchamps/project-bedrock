# Project Bedrock – EKS Retail Store Application

## Overview

Project Bedrock is an Amazon EKS deployment of the Retail Store sample
application. The application is deployed to Kubernetes and exposed
externally using an AWS Application Load Balancer (ALB) through the AWS
Load Balancer Controller.

The project demonstrates Kubernetes application deployment, AWS
integration, IAM permissions, EKS Pod Identity, Kubernetes Ingress, and
ALB target management.

---

## Architecture

The traffic flow is:

User
↓
Internet-facing Application Load Balancer
↓
Kubernetes Ingress
↓
UI Service
↓
UI Pods

The application also contains a Catalog service used by the Retail Store
application.

---

## AWS Resources

The project uses:

- Amazon EKS
- Amazon EC2 worker nodes
- Amazon VPC
- Internet-facing Application Load Balancer
- Elastic Load Balancing
- IAM
- EKS Pod Identity
- Kubernetes Ingress
- Kubernetes Services
- Kubernetes Deployments

---

## Kubernetes Components

The Retail Store application is deployed using Kustomize.

Application configuration:

```text
kubernetes/
└── retail-app/
    ├── base/
    │   ├── catalog.yaml
    │   ├── ui.yaml
    │   ├── ingress.yaml
    │   └── kustomization.yaml
    └── overlays/
        └── production/
