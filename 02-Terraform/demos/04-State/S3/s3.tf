resource "aws_s3_bucket" "b" {
  bucket = "lab-fiap-SUA TURMA-SEU RM"

  tags = {
    Name        = "lab-fiap-SUA TURMA-SEU RM"
    Environment = "admin"
  }
}
