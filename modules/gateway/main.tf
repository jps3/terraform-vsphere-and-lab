variable "datacenter" {}
variable "resource_pool" {}
variable "datastore" {}
variable "vm_folder" {}

# TODO: move this to root and refactor modules/network-structure to also use
locals {
  networks = toset([
    "Bridged",
    "Management",
    "IPS1"
  ])
}

data "vsphere_virtual_machine" "template" {
  name          = "pfsense-2.5.2"
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
  guest_id                   = "otherGuest"
  alternate_guest_name       = "freebsd12_64Guest"
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
    size             = 8
    label            = "disk0"
    thin_provisioned = false
    eagerly_scrub    = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

}

output "guest-ip" {
  value = vsphere_virtual_machine.gateway.*.guest_ip_addresses
}