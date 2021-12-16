packer {
  required_plugins {
    vsphere = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

build {
  sources = [
    "source.vsphere-iso.opnsense"
  ]
  post-processor "manifest" {
    output = "${local.exports_directory}/${var.vm_name}.json"
    custom_data = {
      buildtime               = local.buildtime
      vm_num_cpu              = var.num_cpu
      vm_num_cores            = var.num_cores
      vm_disk_controller_type = var.disk_controller_type
      vm_disk_size            = var.disk_size
      vm_guest_os_type        = var.guest_os_type
      vm_ram                  = var.vm_ram
      vm_network_card_type    = var.network_card_type
      vsphere_cluster         = var.vcenter_cluster
      vsphere_datacenter      = var.vcenter_datacenter
      vsphere_datastore       = var.vcenter_datastore
      vsphere_host            = var.vcenter_host
      vsphere_folder          = var.vcenter_folder
      vsphere_iso_path        = "[${var.vcenter_datastore}] ${var.iso_path}"
    }
  }

}
