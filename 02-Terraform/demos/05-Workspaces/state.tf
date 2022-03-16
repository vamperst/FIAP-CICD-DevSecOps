terraform {
  backend "s3" {
    bucket = "lab-fiap-SUA TURMA-SEU RM"
    key    = "workspaces"
    region = "us-east-1"
  }
}