variable "os_version" {
    type = string
    description = "The OS version to deploy."
}

variable "pool" {
    type = string
    description = "Pool to download files to."
    default = "hdd"
}
