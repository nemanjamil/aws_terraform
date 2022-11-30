terraform {
  backend "s3" {
    bucket = "eks-github-runner-state"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}