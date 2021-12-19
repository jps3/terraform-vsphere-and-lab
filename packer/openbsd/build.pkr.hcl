packer {
  required_plugins {
    vsphere = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

build {
  sources = ["source.vsphere-iso.openbsd"]

  provisioner "shell" {
    pause_before      = "30s"
    pause_after       = "1m"
    expect_disconnect = true
    scripts = [
      "${path.root}/scripts/syspatch.sh",
      "${path.root}/scripts/package-update.sh",
      "${path.root}/scripts/package-installs.sh"
    ]
  }

  provisioner "shell" {
    inline = ["/usr/sbin/groupadd ${var.allowed_ssh_proxy_group}"]
  }

  provisioner "file" {
    content = templatefile("files/adduser.conf.pkrtpl.hcl", {
      encryptionmethod = "auto",
      defaultshell     = "nologin",
      defaultgroup     = "${var.allowed_ssh_proxy_group}",
      defaultclass     = "default"
    })
    destination = "/etc/adduser.conf"
  }

  provisioner "file" {
    content = templatefile("files/sshd_config.pkrtpl.hcl", {
      allow_agent_forwarding  = "no",
      allow_tcp_forwarding    = "no",
      password_authentication = "yes",
      permit_root_login       = "yes",
      allowed_proxy_group     = "${var.allowed_ssh_proxy_group}"
    })
    destination = "/etc/ssh/sshd_config"
  }

  provisioner "file" {
    content = templatefile("files/add_proxy_user.pkrtpl.hcl", {
      allowed_proxy_group = "${var.allowed_ssh_proxy_group}"
    })
    destination = "/usr/local/sbin/add_proxy_user"
  }

  provisioner "shell" {
    inline = [
      "chmod 0750 /usr/local/sbin/add_proxy_user",
      "chown root:wheel /usr/local/sbin/add_proxy_user"
    ]
  }

  post-processor "manifest" {
    output = "${local.exports_directory}/${var.vm_name}.json"
    custom_data = {
      root_password           = var.root_password
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
