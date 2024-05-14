terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      # version = "0.6.11"
    }
  }
}

resource "libvirt_volume" "os_base_rootfs" {
    source = "file:///shares/images/rocky-linux-9.qcow2"
    name = "rocky-linux-9.qcow2"
    pool = var.pool
    format = "qcow2"
}
