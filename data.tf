# ╭─────────────────────────────────╮
# │    ╺┳┓┏━┓╺┳╸┏━┓                 │
# │     ┃┃┣━┫ ┃ ┣━┫                 │
# │    ╺┻┛╹ ╹ ╹ ╹ ╹                 │
# ╰─────────────────────────────────╯

data "vsphere_datacenter" "dc" {
  name = var.vs_datacenter_name
}

data "vsphere_compute_cluster" "cc" {
  name          = var.vs_cluster_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "rp" {
  name          = var.vs_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "vs_esx_host" {
  name          = var.vs_esx_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "sas" {
  name          = var.vs_ds_default
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ssd" {
  name          = var.vs_ds_ssd
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_folder" "vm_folder" {
  path = "/${data.vsphere_datacenter.dc.name}/vm/${var.vm_folder}"
  depends_on = [
    resource.vsphere_folder.vm_folder
  ]
}