# modules/ansible_inventory/main.tf

resource "local_file" "ansible_inventory" {
  filename = var.filename
  content  = templatefile(var.template_file, { vm = var.vms })
}

resource "null_resource" "remove_file" {
  provisioner "local-exec" {
    when    = destroy
    command = "if [ -f ../inventory.yaml ]; then rm ../inventory.yaml; fi"
  }
}