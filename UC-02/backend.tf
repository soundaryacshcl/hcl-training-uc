terraform {
  backend "s3" {
    bucket = "test-s3-bucket-uc-02"
    key    = "usecase2/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
