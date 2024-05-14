variable "root_pool" {
    type = string
    description = "Pool to create root disk in."
    default = "default"
}

variable "mac_addrs" {
    type = list(string)
    description = "List of MAC addresses to pass to each VM for bootstrapping purposes. A worker will be created for each mac address."
}

variable "ram_size" {
    type = number
    description = "How many MiB of RAM to allocate for each node."
    default = 4096
}

variable "vcpu_count" {
    type = number
    description = "Number of vCPUs to allocate for each node."
    default = 2
}

variable "root_disk_size" {
    type = number
    description = "Size in bytes to allocate for root disk"
    default = 53687091200
}

variable "bridge_name" {
    type = string
    description = "Name of bridge interface to create network access on"
}

variable "os_version" {
    type = string
    description = "OS version to deploy"
}

variable "rootfs" {
    type = string
    description = "libvirt volume rootfs id"
}

variable "host" {
    type = string
    description = "hostname of libvirt virt host"
}

variable "autostart" {
  type = string
  description = "start the domain on host boot"
}

variable "cpu" {
    type = string
    description = "CPU mode of the guest OS" 
}
# variable "ssh_private_key" {
#     type = string
#     description = "SSH private key file"
# }
