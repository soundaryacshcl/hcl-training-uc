terraform {
  backend "s3" {
    bucket         = "test-s3-bucket-uc-002"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
  }
}
