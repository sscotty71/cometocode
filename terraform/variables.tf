variable "TARGET_NODE" {
  type = string
  default ="pve2"
}
variable "TARGET_POOL" {
  type = string
  default ="k8s"
}
# variable "VAULT_TOKEN" {
#   type = string
  
#   sensitive = true
# }
variable "proxmox_api_username" {
  type        = string
  description = "The ssh PVE username"
}
variable "proxmox_api_password" {
  type        = string
  description = "The ssh PVE user password"
}
variable "proxmox_api_url" {
  type        = string
  description = "The ssh PVEww host"
}
