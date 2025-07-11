terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "2-tier/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
