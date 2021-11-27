# ╭─────────────────────────────────╮
# │    ┏━┓┏━┓┏━┓╻ ╻╻╺┳┓┏━╸┏━┓┏━┓    │
# │    ┣━┛┣┳┛┃ ┃┃┏┛┃ ┃┃┣╸ ┣┳┛┗━┓    │
# │    ╹  ╹┗╸┗━┛┗┛ ╹╺┻┛┗━╸╹┗╸┗━┛    │
# ╰─────────────────────────────────╯

provider "vsphere" {
  allow_unverified_ssl = true
}


# ╭─────────────────────────────────╮
# │    ╻ ╻┏━┓┏━┓╻┏━┓┏┓ ╻  ┏━╸┏━┓    │
# │    ┃┏┛┣━┫┣┳┛┃┣━┫┣┻┓┃  ┣╸ ┗━┓    │
# │    ┗┛ ╹ ╹╹┗╸╹╹ ╹┗━┛┗━╸┗━╸┗━┛    │
# ╰─────────────────────────────────╯

variable "vm_pfsense_version" {
  type = string
}

variable "insecure_connection" {
  type    = bool
  default = false
}

variable "vsphere_hostname" {
  type    = string
  default = "vsphere.lab.local"
}

variable "esx_host" {
  type    = string
  default = "esx1.lab.local"
}

variable "vsphere_cluster_name" {
  type    = string
  default = "SecLab"
}

variable "ds_sas" {
  type    = string
  default = "sas_datastore1"
}

variable "ds_ssd" {
  type    = string
  default = "ssd_datastore1"
}

variable "vm_pfsense_iso_path" {
  type = string
}

variable "vm_pfsense_iso_checksum" {
  type = string
}

# ╭─────────────────────────────────╮
# │    ╺┳┓┏━┓╺┳╸┏━┓                 │
# │     ┃┃┣━┫ ┃ ┣━┫                 │
# │    ╺┻┛╹ ╹ ╹ ╹ ╹                 │
# ╰─────────────────────────────────╯

data "vsphere_datacenter" "dc" {
  name = "Lab"
}

data "vsphere_compute_cluster" "cc" {
  name          = var.vsphere_cluster_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "esx_host" {
  name          = var.esx_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "sas" {
  name          = var.ds_sas
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ssd" {
  name          = var.ds_ssd
  datacenter_id = data.vsphere_datacenter.dc.id
}


# ╭─────────────────────────────────╮
# │    ┏┳┓┏━┓╺┳┓╻ ╻╻  ┏━╸┏━┓        │
# │    ┃┃┃┃ ┃ ┃┃┃ ┃┃  ┣╸ ┗━┓        │
# │    ╹ ╹┗━┛╺┻┛┗━┛┗━╸┗━╸┗━┛        │
# ╰─────────────────────────────────╯

module "lab_network_structure" {
  vsphere_host_id = data.vsphere_host.esx_host.id
  source          = "./modules/lab-network-structure"
}

module "lab_pfsense" {
  vcenter_datacenter  = data.vsphere_datacenter.dc.name
  vcenter_cluster     = data.vsphere_compute_cluster.cc.name
  vcenter_datastore   = data.vsphere_datastore.ssd.name
  vcenter_host        = data.vsphere_host.esx_host.name
  insecure_connection = var.insecure_connection
  iso_datastore       = data.vsphere_datastore.sas.name
  iso_path            = var.vm_pfsense_iso_path
  iso_checksum        = var.vm_pfsense_iso_checksum
  vm_name             = "pfsense-${var.vm_pfsense_version}"

  source = "./modules/lab-vm-pfsense"
}
