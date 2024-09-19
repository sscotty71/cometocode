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

# variable "local_private_key" {
#     type = string
#     sensitive = true
#     default = "~/.ssh/automation_ed25519"
#     description = "Percorso della chiave privata da usare per collegarsi alla vm con il provisioner remote"

# }


