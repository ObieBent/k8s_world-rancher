# due to limitations with the libvirt provider (it does not properly
# populate the host variable for connections) we only support
# provisioning remote qemu+ssh libvirts :(
#
# 1) host: what host/ip you wish to remotely administer. defaults to localhost
# 2) user: what user to log in as. defaults to root.
# 3) ssh_private_key_path: path to the private ssh key that gets you passwordless access to the user.

# network resource you wish to deploy to.
variable "host" {
  type    = string
  default = "okd.bomar.bme.lab"
}

# user to authenticate to the resource as.
variable "user" {
  type    = string
  default = "borisassogba"
}

# path to private ssh key to allow passwordless access to the user account.
# variable "ssh_private_key_path" {
#   type    = string
#   default = "~/.ssh/id_rsa"
# }

# root disk size
variable "root_disk_size" {
  default = 53687091200 # 50 GiB
}

# Fedora CoreOS version. left blank because this is always set on the command line.
variable "os_version" {

}

variable "autostart" {
  default = true
}

variable "cpu" {
  default = "host-model"
}

##### NODE CONFIGURATION ######

# number of nodes to create on this host
variable "num_nodes" {
  default = 3
}

# how many MiB of ram to allocate for the node
variable "node_ram_size" {
  default = 4096
}

# how many vcpus to allocate for the node
variable "node_vcpu_count" {
  default = 2
}

# mac addresses for the node for reservations
variable node_mac_addrs {
  default = [
    "52:54:00:3e:b7:f7",
    "52:54:00:0b:55:46",
    "52:54:00:a8:99:b6"
  ]
}
