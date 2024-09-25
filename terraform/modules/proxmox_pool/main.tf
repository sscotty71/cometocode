# modules/proxmox_pool/main.tf

resource "proxmox_pool" "come-to-code" {
  poolid  = "come-to-code" 
  comment = "Example of a pool to come-to-code"
}

output "pool_id" {
  value = proxmox_pool.come-to-code.id
}