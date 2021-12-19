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
  default = "opnsense-template"
  # TODO: validation?
}

variable "iso_datastore" {
  type    = string
  default = ""
  # TODO: validation?
}

variable "iso_path" {
  type    = string
  default = ""
  # TODO: validation?
}

variable "iso_checksum" {
  type    = string
  default = ""
  # TODO: validation?
}

variable "guest_os_type" {
  type    = string
  default = "freebsd12_64Guest"
  # TODO: validation?
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
  # TODO: validation?
}

variable "disk_size" {
  type    = number
  default = 8192
  # TODO: validation?
}

variable "num_cpu" {
  type    = number
  default = 1
  # TODO: validation?
}

variable "num_cores" {
  type    = number
  default = 1
  # TODO: validation?
}

variable "vm_ram" {
  type    = number
  default = 1024
  # TODO: validation?
}

variable "network_card_type" {
  type    = string
  default = "vmxnet3"
  # TODO: validation?
}

variable "disk_controller_type" {
  type    = string
  default = "lsilogic"
  # TODO: validation?
}