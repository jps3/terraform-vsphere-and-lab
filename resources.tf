resource "random_string" "lab_id" {
  length  = 4
  upper   = true
  lower   = true
  number  = true
  special = false
}

resource "vsphere_folder" "vm_folder" {
  path          = "${var.vm_folder}-${random_string.lab_id.result}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}