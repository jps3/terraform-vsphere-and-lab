variable "vcenter_server" {
  type    = string
  default = ""
}

variable "vcenter_username" {
  type    = string
  default = "administrator@vsphere.local"
}

variable "vcenter_password" {
  type    = string
  default = ""
}

variable "vcenter_cluster" {
  type    = string
  default = ""
}

variable "vcenter_datacenter" {
  type    = string
  default = ""
}

variable "vcenter_host" {
  type    = string
  default = ""
}

variable "vcenter_datastore" {
  type    = string
  default = ""
}

variable "vcenter_folder" {
  type    = string
  default = "Templates"
}

variable "vcenter_network" {
  type    = string
  default = "VM Network"
}

variable "vm_name" {
  type    = string
  default = "openbsd-template"
}

variable "iso_datastore" {
  type    = string
  default = ""
}

variable "iso_path" {
  type    = string
  default = ""
}

variable "iso_checksum" {
  type    = string
  default = ""
}

variable "guest_os_type" {
  type    = string
  default = "otherGuest64"
}

variable "convert_to_template" {
  type    = bool
  default = true
}

variable "insecure_connection" {
  type    = bool
  default = false
}

variable "vm_hardware_version" {
  type    = string
  default = "14"
}

variable "disk_size" {
  type    = number
  default = 2048
}

variable "num_cpu" {
  type    = number
  default = 1
}

variable "num_cores" {
  type    = number
  default = 1
}

variable "vm_ram" {
  type    = number
  default = 1024
}

variable "output_directory" {
  type    = string
  default = "../exports/openbsd"
}

variable "network_card_type" {
  type    = string
  default = "vmxnet3"
}

variable "disk_controller_type" {
  type    = string
  default = "lsilogic"
}

variable "root_password" {
  type    = string
  default = "P@s5w0rd"
}

variable "first_user_username" {
  type    = string
  default = "vagrant"
}

variable "first_user_password" {
  type    = string
  default = "P@s5w0rd"
  # disable password logins per https://man.openbsd.org/autoinstall
  #default = "*************"
}

variable "first_user_pubkey" {
  type    = string
  default = ""
}

variable "tz" {
  type    = string
  default = "UTC"
}