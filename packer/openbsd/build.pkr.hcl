packer {
  required_plugins {
    vsphere = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vsphere"
    }
    sshkey = {
      version = ">= 0.1.0"
      source  = "github.com/ivoronin/sshkey"
    }
  }
}

data "sshkey" "install" {}

build {
  sources = ["source.vsphere-iso.openbsd"]

  provisioner "file" {
    content     = data.sshkey.install.public_key
    destination = "/tmp/root_ssh_pubkey.txt"
  }

  provisioner "shell" {
    inline = [
      "(echo 'restrict '; cat /tmp/root_ssh_pubkey.txt) >> /root/.ssh/authorized_keys"
    ]
  }

  provisioner "shell" {
    pause_before = "30s"
    pause_after = "30s"
    expect_disconnect = true
    scripts = [
      "${path.root}/scripts/syspatch.sh",
      "${path.root}/scripts/package-update.sh"
    ]
  }

  post-processor "manifest" {
    output = "${local.exports_directory}/${var.vm_name}.json"
    custom_data = {
      root_password           = local.random_password
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
