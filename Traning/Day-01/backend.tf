terraform {
  backend "s3" {
    bucket = "hcl-test-backend-state"
    key    = "usecase2/terraform.tfstate"
    region = "us-east-1"
    #use_lockfile   = true
  }
}
