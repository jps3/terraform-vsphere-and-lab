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
    output_directory = "${local.exports_directory}"
  }

  storage {
    disk_size             = var.disk_size
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

  #cd_files = ["${path.root}/files/*"]
  #cd_label = "backups"

  # Boot commands
  boot_wait = "1m30s"
  boot_command = [
    # Following works with OPNsense 21.7.1
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
    #       (da* appears to be LSI Logic SCSI controller)
    #       (ata* appears to be SATA controller)
    #       (TODO: Maybe pick *ONE* and hard-code it since
    #              we cannot put logic here.)
    #       Options: cd0, da0, ata0, ...?
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
    "<wait1m>",
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
    #   8. Shell
    "8<wait>",
    "<enter><wait2s>",
    #     exit shell
    "exit<wait><enter>",
    #   6. Halt system
    "5<wait>",
    "<enter><wait2s>",
    #     The system will halt and power off [y/N]
    "y<wait>",
    "<enter><wait1m>"
  ]

  communicator = "none"
  remove_cdrom = true
}