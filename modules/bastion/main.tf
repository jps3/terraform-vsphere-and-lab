variable "datacenter" {}
variable "resource_pool" {}
variable "datastore" {}
variable "vm_folder" {}

variable "vm_network" {
  type    = string
  default = "Bridged"
}

locals {
  template_name = "openbsd-7.0-amd64"
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
  name          = var.vm_network
  datacenter_id = var.datacenter.id
}

data "vsphere_host" "hs" {
  name          = "esx1.lab.local"
  datacenter_id = var.datacenter.id
}

resource "vsphere_virtual_machine" "bastion" {
  depends_on                 = [data.vsphere_virtual_machine.template]
  name                       = "bastion"
  resource_pool_id           = var.resource_pool.id
  datastore_id               = var.datastore.id
  folder                     = var.vm_folder
  guest_id                   = "otherGuest64"
  scsi_type                  = data.vsphere_virtual_machine.template.scsi_type
  num_cpus                   = data.vsphere_virtual_machine.template.num_cpus
  memory                     = data.vsphere_virtual_machine.template.memory
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 5

  network_interface {
    network_id     = data.vsphere_network.network.id
    use_static_mac = true
    mac_address    = "00:50:56:ba:2d:8d"
  }

  disk {
    label = "disk0"
    size  = 2
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

}

output "default-ip" {
  value = one(vsphere_virtual_machine.bastion.*.default_ip_address)
}