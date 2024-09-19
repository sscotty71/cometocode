variable "VAULT_TOKEN" {
  description = "Vault token for authentication"
  type        = string
  sensitive   = true
}


variable "sshkeys" {
  type    = string
  default = ""

}
variable "user" {
  type    = string
  default = ""

}

variable "TARGET_NODE" {
  type    = string
  default = "pve"

}

# variable "vms" {
#   type = list(object({
#     name       = string
#     vmid       = number
#     cpu        = number
#     memory     = number
#     image      = string
#     disk_size  = number
#     user       = string
#     nameserver = string
#     sshkeys    = string
#     ipconfig0  = string
#   }))
# }


#  } 
# variable "VM" {
#   description = "Lista delle configurazioni delle VM"
#   type = list(object({
#      vmid  = number
#     name   = string
#     cpu    = number
#     memory = number
#     user   = string
#     nameserver = string
#     image  = string
#     disk_size = number
#     ipconfig0   = string


#   }))
#   default = [
#     {
#       vmid    = 120
#       name    = "pgprimary"
#       cpu     = 1
#       memory  = 1024
#       image   = "ubuntu-noble"
#       user    = "stefano"
#       nameserver = "8.8.8.8"
#       disk_size = 25
#       ipconfig0 = "ip=192.168.173.25/24,gw=192.168.173.254"


#       },
#       {
#         vmid   = 121
#         name   = "pgsecondary"
#         cpu    = 1
#         memory = 1024
#         image  = "ubuntu"
#         user    = "stefano"
#         nameserver = "8.8.8.8"
#         disk_size = 25
#         ipconfig0 = "ip=192.168.173.26/24,gw=192.168.173.254"
#       },
#         {
#          vmid   = 122
#          name   = "pgbackrest"
#          cpu    = 1
#          memory = 1024
#          image  = "ubuntu-noble"
#          user    = "stefano"
#          nameserver = "8.8.8.8"
#          disk_size = 25
#          ipconfig0 = "ip=192.168.173.27/24,gw=192.168.173.254"
#        },
#         {
#          vmid   = 123
#          name   = "bucketserver"
#          cpu    = 1
#          memory = 1024
#          image  = "ubuntu-noble"
#          user    = "stefano"
#          nameserver = "8.8.8.8"
#          disk_size = 25
#          ipconfig0 = "ip=192.168.173.28/24,gw=192.168.173.254"
#        },
#         {
#          vmid   = 124
#          name   = "monitor"
#          cpu    = 1
#          memory = 1024
#          image  = "ubuntu-noble"
#          user    = "stefano"
#          nameserver = "8.8.8.8"
#          disk_size = 25
#          ipconfig0 = "ip=192.168.173.29/24,gw=192.168.173.254"
#        }
#   ]
# }



# #  variable "PROXMOX_PASSWORD" {}
# #  variable "PROXMOX_USERNAME" {}

variable "OS" {
  type    = string
  default = "ubuntu"
}

variable "TEMPLATE" {
  type = map(any)
  default = {
    "ubuntu" = "noble-server"
  }
}