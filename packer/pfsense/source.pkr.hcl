source "vsphere-iso" "pfsense" {
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
    disk_size = var.root_disk_size
    # Thin Provisioned
    disk_thin_provisioned = true
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
  boot_wait = "30s"
  boot_command = [
    # Following works with pfSense 2.5.2
    ##################################################
    # INSTALL
    ##################################################
    #   Copyright and Distribution Notice
    #       Default: Accept
    "<enter><wait>",
    #   Welcome
    #       Options: Install, Rescue Shell, Recover config.xml
    #       Default: Install
    "<enter><wait>",
    #   Keymap Selection
    #       Default: continue with default (US)
    "<enter><wait2s>",
    #   Partitioning
    #       Options: Auto (ZFS), Auto (UFS) Bios, *Auto (UFS) UEFI, Manual, Shell
    #       Default: Auto (ZFS)
    "<enter><wait2s>",
    #   ZFS Configuration Options
    #       Default: Proceed with Installation
    "<enter><wait2s>",
    #       Select Virtual Device type
    #       Default: stripe
    "<enter><wait2s>",
    #       select device
    "<spacebar><wait2s>",
    "<enter><wait2s>",
    #   Installation
    #       Proceed? y/N
    "y",
    "<wait1m>",
    #   Manual Configuration
    #       Default: No
    "<enter><wait2s>",
    #   Complete
    #       Default: Reboot
    "<enter>",
    ##################################################
    # FIRST BOOT
    ##################################################
    "<wait45s>",
    # FIRST BOOT
    #   Should VLANs bet set up now [y|n]?
    "n<wait>",
    "<enter><wait>",
    #   WAN interface name
    "vmx0<wait>",
    "<enter><wait2>",
    #   LAN interface name
    "vmx1<wait>",
    "<enter><wait2>",
    #   OPT interface name
    "vmx2<wait>",
    "<enter><wait2>",
    #   Do you want to proceed? [y|n]
    "y<wait>",
    "<enter><wait1m>",
    # Main menu
    #   13. Update from console
    "13<wait>",
    "<enter><wait2m>",
    #   8. Shell
    "8<wait>",
    "<enter><wait5s>",
    #     Install pfSense-pkg-Open-VM-Tools
    "pkg install -y pfSense-pkg-Open-VM-Tools",
    "<enter><wait30s>",
    #     exit shell
    "exit<wait><enter>",
    #   6. Halt system
    "6<wait>",
    "<enter><wait>",
    #     Do you want to proceed [y|n]?
    "y<wait>",
    "<enter><wait>"
  ]

  communicator = "none"
}