# modules/proxmox_vm/main.tf

resource "proxmox_cloud_init_disk" "ci" {
   name           = "example-CI-disk"
   pve_node       = var.target_node
   storage        = "local"
   meta_data = yamlencode({
     instance_id    = sha1("example")
     local-hostname = "example"
   })
  # vendor_data    = file("cloud-init/vendor.yml")
   user_data      = file("${path.module}/user_info.yaml")

   network_config = yamlencode({
    version = 1
    config = [{
      type = "physical"
      name = "eth0"
      subnets = [{
        type            = "static"
        address         = "192.168.1.100/24"
        gateway         = "192.168.1.1"
        dns_nameservers = ["1.1.1.1", "8.8.8.8"]
      }]
    }]
  })
 }


# Transfer the file to the Proxmox Host
resource "null_resource" "cloud_init_snippets" {
 

  connection {
    type        = "ssh"
    user        = var.ssh_pve_username
    password    = var.ssh_pve_passwd
    host        = var.ssh_pve_host
  }

  provisioner "file" {
    source      = "${path.module}/user_info.yaml"
    destination = "/var/lib/vz/snippets/users.yml"
  }
}


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

  vm_state = var.vms[count.index]["vm_state"]
  scsihw   = "virtio-scsi-single"
  disks {
     ide {
      ide3 {
        cloudinit {
          storage = var.vms[count.index]["storage"]
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.vms[count.index]["disk_size"]
          cache   = "writeback"
          storage = var.vms[count.index]["storage"]
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
  cicustom  = "user=local:snippets/users.yml"

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
