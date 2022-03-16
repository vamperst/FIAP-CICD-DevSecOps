terraform {
  backend "s3" {
    bucket = "teste-rafbarbo-12356"
    key    = "teste"
    region = "us-east-1"
  }
}
