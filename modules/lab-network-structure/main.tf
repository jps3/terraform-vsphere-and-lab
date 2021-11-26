variable "vsphere_host_id" {}

# 
#  “Bridged”
# 
resource "vsphere_host_virtual_switch" "bridged" {
  name             = "Bridged"
  host_system_id   = var.vsphere_host_id
  network_adapters = ["vmnic1", "vmnic2"]
  active_nics      = ["vmnic1"]
  standby_nics     = ["vmnic2"]
}

resource "vsphere_host_port_group" "bridged" {
  name                = "Bridged"
  host_system_id      = var.vsphere_host_id
  virtual_switch_name = vsphere_host_virtual_switch.bridged.name
}


# 
#  “Management”
# 
resource "vsphere_host_virtual_switch" "management" {
  name             = "Management"
  host_system_id   = var.vsphere_host_id
  network_adapters = []
  active_nics      = []
  standby_nics     = []
}

resource "vsphere_host_port_group" "management" {
  name                = "Management"
  host_system_id      = var.vsphere_host_id
  virtual_switch_name = vsphere_host_virtual_switch.management.name
}


# 
#  IPS1
# 
resource "vsphere_host_virtual_switch" "ips1" {
  name                   = "IPS1"
  host_system_id         = var.vsphere_host_id
  network_adapters       = []
  active_nics            = []
  standby_nics           = []
  allow_promiscuous      = true
  allow_mac_changes      = true
  allow_forged_transmits = true
}

resource "vsphere_host_port_group" "ips1" {
  name                = "IPS1"
  host_system_id      = var.vsphere_host_id
  virtual_switch_name = vsphere_host_virtual_switch.ips1.name
}


# 
#  “IPS2”
# 
resource "vsphere_host_virtual_switch" "ips2" {
  name                   = "IPS2"
  host_system_id         = var.vsphere_host_id
  network_adapters       = []
  active_nics            = []
  standby_nics           = []
  allow_promiscuous      = true
  allow_mac_changes      = true
  allow_forged_transmits = true
}

resource "vsphere_host_port_group" "ips2" {
  name                = "IPS2"
  host_system_id      = var.vsphere_host_id
  virtual_switch_name = vsphere_host_virtual_switch.ips2.name
}
