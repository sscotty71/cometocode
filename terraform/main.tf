# main.tf
locals {
  vms = yamldecode(file("vm_info.yaml"))["vms"]
}

module "proxmox_vms" {
  source      = "./modules/proxmox_vm"
  pool        = var.TARGET_POOL
  vm_count    = length(local.vms)
  vms         = local.vms
  target_node = var.TARGET_NODE
}

module "ansible_inventory" {
  source        = "./modules/ansible_inventory"
  filename      = "../inventory.yml"
  template_file = "./modules/ansible_inventory/templates/inventory.tpl"
  vms           = local.vms
}