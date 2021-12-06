source "vsphere-iso" "opnsense" {
  # vSphere settings
  datacenter          = var.vcenter_datacenter
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  host                = var.vcenter_host
  insecure_connection = var.insecure_connection
  cluster             = var.vcenter_cluster
  datastore           = var.vcenter_datastore
  folder              = var.vcenter_folder
  convert_to_template = true

  # VM settings
  vm_name              = var.vm_name
  guest_os_type        = var.guest_os_type
  CPUs                 = var.num_cpu
  RAM                  = var.vm_ram
  RAM_reserve_all      = true
  disk_controller_type = [var.disk_controller_type]

  export {
    force            = true
    output_directory = "${path.root}/${var.output_directory}"
  }

  storage {
    disk_size             = var.root_disk_size
    disk_thin_provisioned = false
    disk_eagerly_scrub    = false
  }

  network_adapters { # WAN
    network      = var.vcenter_network
    network_card = var.network_card_type
  }

  network_adapters { # LAN
    network      = var.vcenter_network
    network_card = var.network_card_type
  }

  network_adapters { # OPT1
    network      = var.vcenter_network
    network_card = var.network_card_type
  }

  iso_paths = [
    "[${var.iso_datastore}] ${var.iso_path}"
  ]

  iso_checksum = var.iso_checksum

  # Boot commands
  boot_wait = "1m30s"
  boot_command = [
    # Following works with opnsense 21.7.1
    ##################################################
    # INSTALL
    ##################################################
    "installer<enter><wait>",
    "opnsense<enter><wait>",
    #   Keymap Selection
    #       Default: continue with default keymap (US)
    "<enter><wait>",
    #   Partitioning
    #       Options: Install (UFS), Install (ZFS), 
    #                Other Modes >>, Import Config, 
    #                Password Reset, Force Reboot
    #       Default: Install (UFS)
    "<enter><wait>",
    #   UFS Configuration: select disk
    #       Options: cd0, da0
    #       Default: cd0
    "d<wait>",
    "<enter><wait>",
    #   UFS Configuration: continue?
    #       Options: Yes, No
    #       Default: No
    "y",
    # ...installation process...
    "<wait2m>",
    #   Final Configuration
    #       Options: Exit, Root Password
    #       Default: Exit
    "<enter>",
    "<wait2m>",
    ##################################################
    # FIRST BOOT
    ##################################################
    "root<enter><wait>",
    "opnsense<enter><wait>",
    # FIRST BOOT
    #   1. interfaces
    "1<wait>",
    "<enter><wait>",
    #   Should VLANs be set up now [y|N]?
    "<enter><wait>",
    #   WAN interface name
    "vmx0<wait>",
    "<enter><wait>",
    #   LAN interface name
    "vmx1<wait>",
    "<enter><wait>",
    #   "OPT1" interface name
    "vmx2<wait>",
    "<enter><wait>",
    #   "OPT2" interface name
    "<enter>",
    #   Do you want to proceed? [y|N]
    "y<wait>",
    "<enter><wait30s>",
    "<wait1h>",
    #   8. Shell
    "8<wait>",
    "<enter><wait5s>",
    #     Install open-vm-tools-nox11 (TODO: install the FUSE kernel module?)
    "pkg install -y open-vm-tools-nox11",
    "<enter><wait30s>",
    #     exit shell
    "exit<wait><enter>",
    # Main menu
    #   12. Update from console
    "12<wait>",
    "<enter><wait30s>",
    #       proceed? [y|N]
    "y<wait>",
    "<enter><wait5m>",
    ##################################################
    # (POSSIBLE) SECOND BOOT
    #   If so would need to log in again, but no
    #   way to check here. Since open-vm-tools
    #   should be installed, we should be able to
    #   let Packer end the process.
    ##################################################
  ]

  communicator            = "none"
  #communicator            = "ssh"
  #pause_before_connecting = "1m"
  #ssh_username            = "root"
  #ssh_password            = "opnsense"
  #shutdown_command        = ""
  remove_cdrom            = true
}