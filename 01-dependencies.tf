resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
      command = "echo ${length(var.dependencies)}"
  }
}

variable "dependencies" {
  type    = "list"
    default = []
}
