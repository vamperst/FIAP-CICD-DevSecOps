terraform {
  backend "s3" {
    bucket = "teste-rafbarbo-12356"
    key    = "gitlab-runner-fleet"
    region = "us-east-1"
  }
}