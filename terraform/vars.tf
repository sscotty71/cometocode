# variable "PROXMOX_API_SECRET" {
#   type = string
# }

# variable "ssh_key" {
#   default = "ssh-rsa AAAAB3NzaC1y..."
# }

# variable "proxmox_host" {
#   default = "proxmox"
# }


# variable "ssh_key" {
#   default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDA20F2OR+1k3G9uqAPVK6jocAmRVwP0ZjeyEpTaqOSBBkzu/hl8HtenWy4DlZ9HZlgTMnzgzkKRuTvLvjRzdWJWFDrcJOYD8Af/9DZiy3eu8wc5For6q0i4JD600PqI2hBC0Kp2f8rTRAW/dsbtM7I90BjZhDDUHpbup/OwvKnEj/edyXUcsV3B64IXXqF//XQYmyKajf8Sc3Zhq8ttEUqSGjDfB9wO+uhtHdEuaFCh4mw3F+dLaBWL6nFP5vW6+UIuQ2AGJ/01xRKv7LRidAms339dbaDvnbID8SY87zaAZzIeNreO2G9aJqSJNZeveRjX/7gA/WuBw2FM4WCraKj stefano.denardis@MacBook-Air-di-Stefano.local"
# }

# variable "proxmox_host" {
#   default = "pve"
# }
# variable "template_name" {
#   default = "noble-server"
# }
variable  "VAULT_TOKEN" {
  default = "hvs.Y5g63HIwkbWGKdQbvmN6gyJb"
}

  variable "template_vm" {
    default = "OL9"
  }

  variable "target_node" {
   default = "pve"
  }
    # web-server1: 
    #       ansible_host: 192.168.173.188
    # web-server2: 
    #       ansible_host: 192.168.173.115
    # tomcat-server1: 
    #       ansible_host: 192.168.173.235
    # tomcat-server2: 
    #       ansible_host: 192.168.173.72
    # pg-server: 
    #       ansible_host: 192.168.173.51
 locals {
   nbs-env-machine = {
     webserver-01 = {
         target_node                = "${var.target_node}" 
         clone                      = "${var.template_vm}" 
         cores                      = 1
         memory                     = 1024
         sockets                    = 1
         storage                    = "local-lvm"
         tags                       = "webserver"
         ipconfig0                  = "ip=192.168.173.180/24,gw=192.168.173.254"
         nameserver                 = "8.8.8.8, 8.8.4.4"

     }

    # webserver-02 = {
    #      target_node                = "${var.target_node}" 
    #      clone                      = "${var.template_vm}" 
    #      cores                      = 1
    #      memory                     = 1024
    #      sockets                    = 1
    #      storage                    = "local-lvm"
    #      tags                       = "webserver"
    #      ipconfig0                  = "ip=192.168.173.181/24,gw=192.168.173.254"
    #      nameserver                 = "8.8.8.8, 8.8.4.4"

    #  }
  
    #  tomcat-01 = {
    #      target_node                = "${var.target_node}" 
    #      clone                      = "${var.template_vm}" 
    #      cores                      = 1
    #      memory                     = 2048
    #      sockets                    = 1
    #      storage                    = "local-lvm"
    #      tags                       = "tomcat"
    #      ipconfig0                  = "ip=192.168.173.185/24,gw=192.168.173.254"
    #      nameserver                 = "8.8.8.8, 8.8.4.4"

    #  }
    #  tomcat-02 = {
    #      target_node                = "${var.target_node}" 
    #      clone                      = "${var.template_vm}" 
    #      cores                      = 1
    #      memory                     = 2048
    #      sockets                    = 1
    #      storage                    = "local-lvm"
    #      tags                       = "tomcat"
    #      ipconfig0                  = "ip=192.168.173.186/24,gw=192.168.173.254"
    #      nameserver                 = "8.8.8.8, 8.8.4.4"

    #  }
  
    #   pg-server = {
    #      target_node                = "${var.target_node}" 
    #      clone                      = "${var.template_vm}" 
    #      cores                      = 1
    #      memory                     = 2048
    #      sockets                    = 1
    #      storage                    = "local-lvm"
    #      tags                       = "postgresql"
    #      ipconfig0                  = "ip=192.168.173.189/24,gw=192.168.173.254"
    #      nameserver                 = "8.8.8.8, 8.8.4.4"
    #   }
      #  ks-server = {
      #    target_node                = "${var.target_node}" 
      #    clone                      = "${var.template_vm}" 
      #    cores                      = 1
      #    memory                     = 1024
      #    sockets                    = 1
      #    storage                    = "local-lvm"
      #    tags                       = "ks_server"
      #    ipconfig0                  = "ip=192.168.173.110/24,gw=192.168.173.254"
      #    nameserver                 = "8.8.8.8, 8.8.4.4"
      # }
   }
 }

