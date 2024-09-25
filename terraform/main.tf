# main.tf
locals {
  vms = yamldecode(file("vm_info.yaml"))["vms"]
}


module "proxmox_pool" {
  source      = "./modules/proxmox_pool"
  pool_name   = var.TARGET_POOL
  target_node = var.TARGET_NODE
  
}

module "proxmox_vms" {
  source      = "./modules/proxmox_vm"
  pool        = var.TARGET_POOL
  vm_count    = length(local.vms)
  vms         = local.vms
  target_node = var.TARGET_NODE
  depends_on = [module.proxmox_pool]
}

module "ansible_inventory" {
  source        = "./modules/ansible_inventory"
  filename      = "../inventory.yml"
  template_file = "./modules/ansible_inventory/templates/inventory.tpl"
  vms           = local.vms
}


#Terraform distruggerà le risorse in ordine inverso rispetto alla creazione.
#La VM verrà distrutta prima perché il null_resource aggiunge una dipendenza che forza Terraform a distruggere la VM prima del pool.

resource "null_resource" "ensure_pool_destroy_after_vm" {
  depends_on = [module.proxmox_vms]
} 