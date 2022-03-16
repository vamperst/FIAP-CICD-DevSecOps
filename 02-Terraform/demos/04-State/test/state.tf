terraform {
  backend "s3" {
    bucket = "lab-fiap-SUA TURMA-SEU RM"
    key    = "teste"
    region = "us-east-1"
  }
}