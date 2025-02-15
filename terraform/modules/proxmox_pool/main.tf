# modules/proxmox_pool/main.tf

resource "proxmox_pool" "ansible-test" {
  poolid  = "ansible-test" 
  comment = "Example of a pool to ansible-test"
}

output "pool_id" {
  value = proxmox_pool.ansible-test.id
}