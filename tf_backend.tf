terraform {
  backend "s3" {
    bucket = "terraform-20190927145631752200000007"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
