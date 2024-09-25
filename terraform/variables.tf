variable "TARGET_NODE" {
  type = string
  default ="pve"
}
variable "TARGET_POOL" {
  type = string
  default ="come-to-code"
}
variable "VAULT_TOKEN" {
  type = string
  
  sensitive = true
}
