# ╭─────────────────────────────────╮
# │    ╻ ╻┏━┓┏━┓╻┏━┓┏┓ ╻  ┏━╸┏━┓    │
# │    ┃┏┛┣━┫┣┳┛┃┣━┫┣┻┓┃  ┣╸ ┗━┓    │
# │    ┗┛ ╹ ╹╹┗╸╹╹ ╹┗━┛┗━╸┗━╸┗━┛    │
# ╰─────────────────────────────────╯

variable "vs_insecure_connection" {
  type    = bool
  default = false
}

variable "vs_datacenter_name" {
  type    = string
  default = "dc"
}

variable "vs_hostname" {
  type    = string
  default = "vsphere.local"
}

variable "vs_esx_host" {
  type    = string
  default = "esxi.local"
}

variable "vs_cluster_name" {
  type    = string
  default = "homelab"
}

variable "vs_resource_pool" {
  type    = string
  default = "resource_pool_0"
}

variable "vs_ds_default" {
  type    = string
  default = "datastore1"
}

variable "vs_ds_ssd" {
  type    = string
  default = "datastore2"
}

variable "vm_folder" {
  type    = string
  default = "VMs"
}