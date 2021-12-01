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

  export {
    force                = true
    output_directory     = var.output_directory
  }

  CPUs            = var.num_cpu
  RAM             = var.vm_ram
  RAM_reserve_all = true
  disk_controller_type = [var.disk_controller_type]

  storage {
    disk_size             = var.root_disk_size
    disk_thin_provisioned = false
    disk_eagerly_scrub    = true
  }

  network_adapters { # WAN
    network      = var.vcenter_network
    network_card = var.network_card_type
  }
  network_adapters { # LAN
    network_card = var.network_card_type
  }
  network_adapters { # OPT1
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
    #       Options: Auto (ZFS), Auto (UFS) Bios, *Auto (UFS) UEFI, Manual, Shell
    #       Default: Auto (ZFS)
    #"A<wait>",
    "<enter><wait>",
    #   UFS Configuration
    #       Configuration Options
    #       Default: Proceed with Installation
    "<enter><wait>",
    #       Select Virtual Device type
    #       Default: stripe
    "<enter><wait>",
    #       select device
    "<spacebar><wait>",
    "<enter><wait>",
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
    "n<wait>",
    "<enter><wait>",
    #   WAN interface name
    "vmx0<wait>",
    "<enter><wait>",
    #   LAN interface name
    "vmx1<wait>",
    "<enter><wait>",
    #   OPT interface name
    "vmx2<wait>",
    "<enter><wait>",
    #   Do you want to proceed? [y|n]
    "y<wait>",
    "<enter><wait1m30s>",
    # Main menu
    #   Update from console
    "13<wait><enter>",
    #   Shell
    "8<wait><enter>",
    #   Install pkg pfSense-pkg-Open-VM-Tools
    "pkg install -y pfSense-pkg-Open-VM-Tools<wait>",
    "<enter><wait1m>",
    "exit<wait><enter>",
    #   Halt system
    "6<wait>",
    "<enter><wait>",
    #   Do you want to proceed? [y|n]
    "y<enter>"
  ]

  communicator = "none"
}