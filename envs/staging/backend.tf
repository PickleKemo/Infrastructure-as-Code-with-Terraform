terraform {
  backend "s3" {
    bucket         = "acme-terraform-state"
    key            = "envs/staging/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "acme-terraform-locks"
    encrypt        = true
  }
}