output "filename" {
  value = "${local_file.test.filename}"
  description = "The name of the file to be exported with the extension, e.g. in default workspace = foo-dev.txt, in prod workspace = foo-prod.txt"
}

output "content" {
  value = "${local_file.test.content}"
  description = "The content of the file to be exported"
}