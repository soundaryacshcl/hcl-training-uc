terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
