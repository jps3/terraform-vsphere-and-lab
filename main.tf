provider "vsphere" {
  allow_unverified_ssl = true
}

variable "vsphere_hostname" {
  type    = string
  default = "esx1.lab.local"
}

variable "vsphere_cluster_name" {
  type    = string
  default = "SecLab"
}

data "vsphere_datacenter" "dc" {
  name = "Lab"
}

data "vsphere_compute_cluster" "cc" {
  name          = var.vsphere_cluster_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_hostname
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "vm_net" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "lab-network-structure" {
  vsphere_host_id = data.vsphere_host.host.id
  source          = "./modules/lab-network-structure"
}

