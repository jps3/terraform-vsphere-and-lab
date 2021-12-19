source "vsphere-iso" "openbsd" {
  # vSphere settings
  datacenter          = var.vcenter_datacenter
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  host                = var.vcenter_host
  insecure_connection = var.insecure_connection
  cluster             = var.vcenter_cluster
  resource_pool       = var.vcenter_resource_pool
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
    output_directory = "${local.exports_directory}"
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
    # 
    # Default or unused autoinstall settings are commented out
    # 
    "S<enter>",
    "cat <<EOF >>install.conf<enter>",
    "System hostname = ${var.vm_name}<enter>",
    #"Which network interface do you wish to configure = vmx0<enter>",
    #"IPv4 address for vmx0 = autoconf<enter>",
    #"IPv6 address for vmx0 = none<enter>",
    #"Which network interface do you wish to configure = done<enter>",
    "Password for root = ${var.root_password}<enter>",
    #"Start sshd(8) by default = yes<enter>",
    "Do you expect to run the X Window System = no<enter>",
    #"Setup a user = ${var.first_user_username}<enter>",
    #"Full name for user ${var.first_user_username} = ${var.first_user_username}<enter>",
    #"Password for user ${var.first_user_username} = ${var.first_user_password}<enter>",
    #"Public ssh key for user ${var.first_user_username} = ${var.first_user_pubkey}<enter>",
    "Allow root ssh login = yes<enter>",
    "What timezone are you in = ${var.tz}<enter>",
    #"Which disk is the root disk = sd0<enter>",
    "Use (W)hole disk MBR, whole disk (G)PT, (O)penBSD area or (E)dit = W<enter>",
    "Use (A)uto layout, (E)dit auto layout, or create (C)ustom layout = A<enter>",
    "Location of sets = cd<enter>",
    "Set name(s) = -* base* bsd* man*<enter>",
    "Directory does not contain SHA256.sig. Continue without verification = yes<enter>",
    "EOF<enter>",
    "install -af install.conf && reboot<enter>"
  ]
  communicator              = "ssh"
  ssh_username              = "root"
  ssh_password              = "${var.root_password}"
  ssh_clear_authorized_keys = true
  shutdown_command          = "halt -p"
  remove_cdrom              = true
}