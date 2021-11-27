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
  vm_name = var.vm_name

  CPUs            = var.num_cpu
  RAM             = var.vm_ram
  RAM_reserve_all = true

  storage {
    disk_size = var.root_disk_size
  }

  network_adapters { # WAN
    network      = var.vcenter_network
    network_card = "vmxnet3"
  }
  network_adapters { # LAN
    network_card = "vmxnet3"
  }
  network_adapters { # OPT1
    network_card = "vmxnet3"
  }

  iso_paths = [
    "[${var.iso_datastore}] ${var.iso_path}"
  ]
  iso_checksum = var.iso_checksum

  # Boot commands
  boot_wait = "30s"
  boot_command = [
    ##################################################
    # INSTALL
    ##################################################
    #   Copyright
    "<enter><wait>",
    #   Welcome
    #       Options: Install, Rescue Shell, Recover config.xml
    #       Default: Install
    "<enter><wait>",
    #   Keymap Selection
    #       Default: continue with default (US)
    "<enter><wait>",
    #   Partitioning
    #       Options: Auto (ZFS), Auto (UFS) Bios, Auto (UFS) UEFI, Manual, Shell
    #       Default: Auto (ZFS)
    "<enter><wait>",
    #   ZFS Configuration
    #       Configuration Options
    #       Default: Proceed with Installation
    "<enter><wait>",
    #       Select Virtual Device type
    #       Default: stripe
    "<enter><wait>",
    #       select device
    "<spacebar><wait><enter><wait>",
    #       Proceed? y/N
    "y",
    #       ... wait for installation ...
    "<wait1m>",
    #   Manual Configuration
    #       Default: No
    "<enter><wait>",
    #   Complete
    #       Default: Reboot
    "<enter>",
    ##################################################
    # FIRST BOOT
    ##################################################
    "<wait1m>",
    # FIRST BOOT
    #   Should VLANs bet set up now [y|n]?
    "n<wait2s><enter><wait2s>",
    #   WAN interface name
    "vmx0<wait2s><enter><wait2s>",
    #   LAN interface name
    "vmx1<wait2s><enter><wait2s>",
    #   OPT interface name
    "vmx2<wait2s><enter><wait2s>",
    #   Do you want to proceed? [y|n]
    "y<wait><enter><wait1m>",
    # Main menu
    #   Halt system
    "6<wait><enter><wait>",
    #   Do you want to proceed? [y|n]
    "y<enter>"
  ]
  # We don't need to do anything further in packer for now
  # If we did, we would have to install qemu utils to discover IP & configure ssh communicator
  communicator = "none"
}