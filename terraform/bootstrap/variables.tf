variable "region" {
  description = "AWS region for the Project Bedrock infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket used for Terraform remote state."
  type        = string
}