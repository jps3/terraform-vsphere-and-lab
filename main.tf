# ╭─────────────────────────────────╮
# │    ┏━┓┏━┓┏━┓╻ ╻╻╺┳┓┏━╸┏━┓┏━┓    │
# │    ┣━┛┣┳┛┃ ┃┃┏┛┃ ┃┃┣╸ ┣┳┛┗━┓    │
# │    ╹  ╹┗╸┗━┛┗┛ ╹╺┻┛┗━╸╹┗╸┗━┛    │
# ╰─────────────────────────────────╯

provider "vsphere" {
  allow_unverified_ssl = var.vs_insecure_connection
}


# ╭─────────────────────────────────╮
# │    ┏┳┓┏━┓╺┳┓╻ ╻╻  ┏━╸┏━┓        │
# │    ┃┃┃┃ ┃ ┃┃┃ ┃┃  ┣╸ ┗━┓        │
# │    ╹ ╹┗━┛╺┻┛┗━┛┗━╸┗━╸┗━┛        │
# ╰─────────────────────────────────╯

module "network_structure" {
  vsphere_host_id = data.vsphere_host.vs_esx_host.id
  source          = "./modules/network-structure"
}

module "packer_pfsense" {
  vcenter_datacenter     = data.vsphere_datacenter.dc.name
  vcenter_cluster        = data.vsphere_compute_cluster.cc.name
  vcenter_datastore      = data.vsphere_datastore.ssd.name
  vcenter_host           = data.vsphere_host.vs_esx_host.name
  vs_insecure_connection = var.vs_insecure_connection
  iso_datastore          = data.vsphere_datastore.sas.name
  iso_path               = var.vm_pfsense_iso_path
  iso_checksum           = var.vm_pfsense_iso_checksum
  vm_name                = "pfsense-${var.vm_pfsense_version}"

  source = "./modules/packer-pfsense"
}
