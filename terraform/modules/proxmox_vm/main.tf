# modules/proxmox_vm/main.tf

# Autore: Stefano De Nardis
# Email: stefano.denardis@klonet.it
# Esempio per cometocode 2024


resource "proxmox_vm_qemu" "cloudinit" {
  count = var.vm_count

  vmid = var.vms[count.index]["vmid"]
  name = var.vms[count.index]["name"]

  target_node = var.target_node

  clone = var.vms[count.index]["image"]
  agent = 1

  os_type = "cloud-init"

  cores  = var.vms[count.index]["cpu"]
  memory = var.vms[count.index]["memory"]

  pool = var.pool

  vm_state = "started"
  scsihw   = "virtio-scsi-single"
  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.vms[count.index]["disk_size"]
          cache   = "writeback"
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  boot       = "order=scsi0;net0"
  nameserver = var.vms[count.index]["nameserver"]
  ipconfig0  = var.vms[count.index]["ipconfig0"]

  ciuser  = var.vms[count.index]["user"]
  sshkeys = var.vms[count.index]["sshkeys"]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.ssh_host
    private_key = file("~/.ssh/automation_ed25519") # Destroy-time provisioners and their connection configurations may only reference attributes of the related resource, via 'self', 'count.index', or 'each.key'.
    port        = self.ssh_port
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo halt -p"
    ]
  }
}
