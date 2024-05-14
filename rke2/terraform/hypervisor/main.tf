terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      # version = "0.6.2"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://${var.user}@${var.host}:2222/system"
}

module "os_base" {
  source = "../modules/os-base"

  os_version = var.os_version
}

module "stacks_node" {
  source = "../modules/node"

  root_pool      = "hdd"
  mac_addrs      = var.node_mac_addrs
  ram_size       = var.node_ram_size
  vcpu_count     = var.node_vcpu_count
  root_disk_size = var.root_disk_size
  bridge_name    = "ocpnet"
  os_version     = var.os_version
  rootfs         = module.os_base.os_base_rootfs
  host           = var.host
  autostart      = var.autostart
  cpu            = var.cpu
  # ssh_private_key = file(var.ssh_private_key_path)
}
