variable "datacenter" {}
variable "resource_pool" {}
variable "datastore" {}
variable "vm_folder" {}

# TODO: 
#   - If   template_name contains 'pfSense'  then iface/network order is WAN, LAN, OPT1
#   - Elif template_name contains 'opnsense' then iface/network order is LAN, WAN, OPT1
#   - Create mapping of network name <--> fixed mac address

locals {
  template_name = "pfsense-2.5.2-amd64"
  networks = tomap({
    "Bridged" : "00:50:56:ba:d8:16",
    "Management" : null,
    "IPS1" : null
  })
}

#locals {
#  template_name = "opnsense-21.7.1-amd64"
#  networks = tomap({
#    "Management" : null,
#    "Bridged" : "00:50:56:ba:d8:16",
#    "IPS1" : null
#  })
#}

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

#resource "null_resource" "timer" {
#  provisioner "local-exec" {
#    command = "sleep 1200"
#  }
#}

resource "vsphere_virtual_machine" "gateway" {
  name                       = "gateway"
  resource_pool_id           = var.resource_pool.id
  datastore_id               = var.datastore.id
  folder                     = var.vm_folder
  guest_id                   = "freebsd12_64Guest"
  scsi_controller_count      = 1
  scsi_type                  = data.vsphere_virtual_machine.template.scsi_type
  num_cpus                   = 1
  memory                     = 2048
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 5

  dynamic "network_interface" {
    for_each = local.networks
    content {
      network_id     = data.vsphere_network.network[network_interface.key].id
      use_static_mac = local.networks[data.vsphere_network.network[network_interface.key].name] == null ? false : true
      mac_address    = local.networks[data.vsphere_network.network[network_interface.key].name] == null ? "" : local.networks[data.vsphere_network.network[network_interface.key].name]
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
  #depends_on = [resource.null_resource.timer]
}