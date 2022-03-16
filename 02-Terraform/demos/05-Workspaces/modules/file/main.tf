locals {
  env = "${terraform.workspace}"

  // Isolate variables used for different workspaces
  // using map
  context = {
    default = {
      name = "${var.filename}-dev.txt"
    }
    dev = {
      name = "${var.filename}-dev.txt"
    }
    homol = {
      name = "${var.filename}-homol.txt"
    }
    prod = {
      name = "${var.filename}-prod.txt"
    }
  }

  context_variables = "${local.context[local.env]}"
}

// Creates a new local file with the given filename and content
resource "local_file" "test" {
  content     = "${local.env}"
  filename = "${path.module}/${lookup(local.context_variables, "name")}"
}