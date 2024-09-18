# Leggi il file YAML
locals {
  vms = yamldecode(file("vm_info.yaml"))["vms"]
  validate_vms = length(local.vms) > 0 ? true : error("L'inventario JSON è vuoto. Nessuna VM da creare.")
}

# locals {
#   users = yamldecode(file("users.yaml"))["users"]
#   validate_users = length(local.users) > 0 ? true : error("L'inventario users JSON è vuoto. Nessuna VM da creare.")
# }


resource "proxmox_vm_qemu" "cloudinit-test" {
    count = length(local.vms)
     
     vmid = local.vms[count.index]["vmid"]
     name = local.vms[count.index]["name"]
      
     target_node = var.TARGET_NODE
 
     clone = local.vms[count.index]["image"]
    # Activate QEMU agent for this VM
     agent = 1

    os_type = "cloud-init"

    cores  = local.vms[count.index]["cpu"]
    memory = local.vms[count.index]["memory"]

    pool = "come-to-code"
   

    vm_state    = "started"
    scsihw      = "virtio-scsi-single"
    
    disks {
        ide {
            ide3 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
         scsi {
           scsi0 {
            disk {
                    size            =  local.vms[count.index]["disk_size"]
                    cache           = "writeback"
                    storage         = "local-lvm"
             
                }
            }
        }
    }

    # Setup the network interface and assign a vlan tag: 256
    network {
        model = "virtio"
        bridge = "vmbr0"
       // tag = 256
    }

    # Setup the ip address using cloud-init.
   
      boot        = "order=scsi0;net0"

    # Keep in mind to use the CIDR notation for the ip.
     
     nameserver = local.vms[count.index]["nameserver"]
     ipconfig0 = local.vms[count.index]["ipconfig0"]

     ciuser = local.vms[count.index]["user"]
     sshkeys = <<EOF
      ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDA20F2OR+1k3G9uqAPVK6jocAmRVwP0ZjeyEpTaqOSBBkzu/hl8HtenWy4DlZ9HZlgTMnzgzkKRuTvLvjRzdWJWFDrcJOYD8Af/9DZiy3eu8wc5For6q0i4JD600PqI2hBC0Kp2f8rTRAW/dsbtM7I90BjZhDDUHpbup/OwvKnEj/edyXUcsV3B64IXXqF//XQYmyKajf8Sc3Zhq8ttEUqSGjDfB9wO+uhtHdEuaFCh4mw3F+dLaBWL6nFP5vW6+UIuQ2AGJ/01xRKv7LRidAms339dbaDvnbID8SY87zaAZzIeNreO2G9aJqSJNZeveRjX/7gA/WuBw2FM4WCraKj stefano.denardis@MacBook-Air-di-Stefano.local
     EOF

   connection {
       type     = "ssh"
       user     = "ubuntu"
       host     = self.ssh_host
       private_key = "${file("~/.ssh/automation_ed25519")}"
       port     = self.ssh_port
     }

# Provisioner per spegnere la VM prima di distruggerla
   provisioner "remote-exec" {
     when = destroy 
     inline = [
        "sudo halt -p"
     ]
   }

}



resource "local_file" "ansible_inventory" {
  filename = "../inventory.yml"
  content = <<EOF

${templatefile("../inventory.tpl", { vm = local.vms })}
EOF
}


resource "null_resource" "remove_file" {
  provisioner "local-exec" {
    when = destroy 
    command = "if [ -f ../inventory.yaml ]; then rm ../inventory.yaml; fi"
  }
}