source "vsphere-iso" "openbsd" {
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
  iso_paths            = ["[${var.iso_datastore}] ${var.iso_path}"]
  iso_checksum         = var.iso_checksum

  export {
    force            = true
    output_directory = "${path.root}/${var.output_directory}"
  }

  storage {
    disk_size = var.disk_size
    # Thin Provisioned
    disk_thin_provisioned = true
    disk_eagerly_scrub    = false
  }

  network_adapters { # WAN
    network      = var.vcenter_network
    network_card = var.network_card_type
  }

  boot_wait = "30s"
  boot_command = [
    "S<enter>",
    "cat <<EOF >>install.conf<enter>",
    "System hostname = ${var.vm_name}<enter>",
    # Which network interface do you wish to configure = «vmx0»
    # IPv4 address for «vmx0» = «autoconf»
    # IPv6 address for «vmx0» = «none»
    # Which network interface do you wish to configure = done»
    "Password for root = ${var.root_password}<enter>",
    # Start sshd(8) by default = «yes»
    "Do you expect to run the X Window System = no<enter>",
    "Setup a user = ${var.first_user_username}<enter>",
    # Full name for user ${var.first_user_username} = ${var.first_user_username}
    "Password for user ${var.first_user_username} = ${var.first_user_password}<enter>",
    #"Public ssh key for user ${var.first_user_username} = ${var.first_user_pubkey}<enter>",
    "Allow root ssh login = yes<enter>",
    "What timezone are you in = ${var.tz}<enter>",
    # Which disk is the root disk = «sd0»
    "Use (W)hole disk MBR, whole disk (G)PT, (O)penBSD area or (E)dit = W<enter>",
    "Use (A)uto layout, (E)dit auto layout, or create (C)ustom layout = A<enter>",
    "Location of sets = cd<enter>",
    "Set name(s) = -* base* bsd*<enter>",
    "Directory does not contain SHA256.sig. Continue without verification = yes<enter>",
    "EOF<enter>",
    "install -af install.conf && reboot<enter>"
  ]
  communicator            = "ssh"
  pause_before_connecting = "1m"
  ssh_username            = "root"
  ssh_password            = "${var.root_password}"
  shutdown_command        = "halt -p"
  remove_cdrom            = true
}