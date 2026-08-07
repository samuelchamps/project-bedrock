terraform {
  backend "s3" {
    bucket       = "project-bedrock-tfstate-alt-soe-tin-025-0048"
    key          = "project-bedrock/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}