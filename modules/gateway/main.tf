variable "datacenter" {}
variable "resource_pool" {}
variable "datastore" {}
variable "vm_folder" {}

locals {
  template_name = "pfsense-2.5.2-amd64"

  networks = toset([
    "Bridged",
    "Management",
    "IPS1"
  ])
}

data "vsphere_virtual_machine" "template" {
  name          = local.template_name
  datacenter_id = var.datacenter.id
}

data "vsphere_datastore" "ds" {
  name          = var.datastore.name
  datacenter_id = var.datastore.datacenter_id
}

data "vsphere_network" "network" {
  for_each      = local.networks
  name          = each.key
  datacenter_id = var.datacenter.id
}

data "vsphere_host" "hs" {
  name          = "esx1.lab.local"
  datacenter_id = var.datacenter.id
}

resource "vsphere_virtual_machine" "gateway" {
  name                       = "gateway"
  resource_pool_id           = var.resource_pool.id
  datastore_id               = var.datastore.id
  folder                     = var.vm_folder
  guest_id                   = "freebsd12_64Guest"
  scsi_type                  = data.vsphere_virtual_machine.template.scsi_type
  num_cpus                   = data.vsphere_virtual_machine.template.num_cpus
  memory                     = data.vsphere_virtual_machine.template.memory
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 5

  dynamic "network_interface" {
    for_each = local.networks
    content {
      network_id = data.vsphere_network.network[network_interface.key].id
    }
  }

  disk {
    label = "disk0"
    size  = 8
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

}

output "default-ip" {
  value = one(vsphere_virtual_machine.gateway.*.default_ip_address)
}