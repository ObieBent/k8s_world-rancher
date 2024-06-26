terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    #   version = "0.6.11"
    }
  }
}


resource "libvirt_volume" "node_root_disk" {
    count = length(var.mac_addrs)
    name = "node_${count.index +1}"
    pool = var.root_pool
    size = var.root_disk_size

    provisioner "remote-exec" {
        inline = [
            "sudo dd if=${var.rootfs} of=/srv/libvirt/hdd/${self.name} oflag=direct bs=10M"
        ]

        connection {
            type        = "ssh"
            user        = "borisassogba"
            host        = var.host
            port        = 2222
            # Allow to use ssh private key protected by a passphrase
            # Please load this private key before
            # ssh-add = ~/.ssh/id_rsa
            agent       = true
            # private_key = var.ssh_private_key
        }
    }
}


resource "libvirt_domain" "node" {
    count = length(var.mac_addrs)
    name = "node_${count.index +1}"
    memory = var.ram_size
    vcpu = var.vcpu_count

    autostart = var.autostart

    cpu {
        mode = var.cpu
    }

    network_interface {
        bridge = var.bridge_name
        mac = element(var.mac_addrs, count.index)
    }

    video {
        type = "virtio"
    }

    graphics {
        type = "vnc" 
        listen_type = "address"
    }

    disk {
        volume_id = element(libvirt_volume.node_root_disk.*.id, count.index)
    }

    console {
      type        = "pty"
      target_port = "0"
      target_type = "serial"
    }

    console {
      type        = "pty"
      target_type = "virtio"
      target_port = "1"
    }
}
