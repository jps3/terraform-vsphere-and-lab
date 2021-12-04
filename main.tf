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

module "gateway" {
  datacenter    = data.vsphere_datacenter.dc
  resource_pool = data.vsphere_resource_pool.rp
  datastore     = data.vsphere_datastore.ssd
  vm_folder     = data.vsphere_folder.vm_folder.path
  source        = "./modules/gateway"
  depends_on = [
    module.network_structure,
    resource.vsphere_folder.vm_folder
  ]
}

module "bastion" {
  datacenter    = data.vsphere_datacenter.dc
  resource_pool = data.vsphere_resource_pool.rp
  datastore     = data.vsphere_datastore.ssd
  vm_folder     = data.vsphere_folder.vm_folder.path
  source        = "./modules/bastion"
  depends_on = [
    module.network_structure,
    resource.vsphere_folder.vm_folder
  ]
}
