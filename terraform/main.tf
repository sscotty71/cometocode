resource "proxmox_vm_qemu" "cloudinit-test" {
    # name = "terraform-test-vm"
    # desc = "A test for using terraform and cloudinit"
    for_each = { for vm in var.VM : vm.name => vm }
     name = each.value.name
     vmid = each.value.vmid

     target_node = var.TARGET_NODE
    //desc = "A test for using terraform and cloudinit"
 
   # clone = "lookup(var.TEMPLATE, "ubuntu")"
    clone = "ubuntu-noble"
    # Activate QEMU agent for this VM
     agent = 0

    os_type = "cloud-init"
   
    cores = 2
    sockets = 1
    vcpus = 0
   cpu         = "host"
  memory      =  1024

    vm_state    = "started"
    #scsihw = "lsi" 
    scsihw      = "virtio-scsi-single"
    # Setup the disk
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
                    size            =  each.value.disk_size
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
     ciuser = each.value.user
     nameserver = each.value.nameserver
     ipconfig0 = each.value.ipconfig0
     sshkeys = <<EOF
      ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDA20F2OR+1k3G9uqAPVK6jocAmRVwP0ZjeyEpTaqOSBBkzu/hl8HtenWy4DlZ9HZlgTMnzgzkKRuTvLvjRzdWJWFDrcJOYD8Af/9DZiy3eu8wc5For6q0i4JD600PqI2hBC0Kp2f8rTRAW/dsbtM7I90BjZhDDUHpbup/OwvKnEj/edyXUcsV3B64IXXqF//XQYmyKajf8Sc3Zhq8ttEUqSGjDfB9wO+uhtHdEuaFCh4mw3F+dLaBWL6nFP5vW6+UIuQ2AGJ/01xRKv7LRidAms339dbaDvnbID8SY87zaAZzIeNreO2G9aJqSJNZeveRjX/7gA/WuBw2FM4WCraKj stefano.denardis@MacBook-Air-di-Stefano.local
     EOF
 # Aggiungi altre configurazioni della VM...

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

${templatefile("../inventory.tpl", { vm = var.VM })}
EOF
}


resource "null_resource" "remove_file" {
  provisioner "local-exec" {
    when = destroy 
    command = "if [ -f ../inventory.yaml ]; then rm ../inventory.yaml; fi"
  }
}