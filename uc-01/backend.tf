terraform {
  backend "s3" {
    bucket = "hcl-training-uc-01-bucket"
    key    = "uc-01/terraform.tfstate"
    region = "us-east-1"
  }
}
