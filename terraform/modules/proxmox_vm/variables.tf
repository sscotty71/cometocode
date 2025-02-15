variable "vm_count" {
  type = number
}

variable "vms" {
  type = list(map(any))
}

variable "target_node" {
  type = string
}
variable "pool" {
  type = string
}

variable "os_type" {
  type = string
  default = "cloud-init"
}

# variable "ssh_pve_username" {
#   type        = string
#   description = "The ssh PVE username"
# }
# variable "ssh_pve_passwd" {
#   type        = string
#   description = "The ssh PVE user password"
# }
# variable "ssh_pve_host" {
#   type        = string
#   description = "The ssh PVE host"
# }


# variable "proxmox_api_username" {
#   type        = string
#   description = "The ssh PVE username"
# }
# variable "proxmox_api_password" {
#   type        = string
#   description = "The ssh PVE user password"
# }
# variable "proxmox_api_url" {
#   type        = string
#   description = "The ssh PVE host"
# }

# variable "local_private_key" {
#     type = string
#     sensitive = true
#     default = "~/.ssh/automation_ed25519"
#     description = "Percorso della chiave privata da usare per collegarsi alla vm con il provisioner remote"

# }


