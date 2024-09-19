variable "TARGET_NODE" {
  type = string
  default ="pve"
}
variable "TARGET_POOL" {
  type = string
  default ="cometocode"
}
variable "VAULT_TOKEN" {
  type = string
  default ="token"
  sensitive = true
}
