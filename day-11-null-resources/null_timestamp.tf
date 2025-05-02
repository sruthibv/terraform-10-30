# resource "null_resource" "example" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   provisioner "local-exec" {
#     command = "echo 'Running some setup locally'"
#   }
# }


