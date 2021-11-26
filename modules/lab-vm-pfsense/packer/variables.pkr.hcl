variable "vcenter_server" {}
variable "vcenter_username" {}
variable "vcenter_password" {}
variable "vcenter_cluster" {}
variable "vcenter_datacenter" {}
variable "vcenter_host" {}
variable "vcenter_datastore" {}
variable "vcenter_folder" {}
variable "vm_network" {}
variable "vm_name" {}
variable "iso_path" {}
variable "iso_checksum" {}
variable "guest_os_type" {}

variable "vm_hardware_version" {
  default = "14"
}
variable "root_disk_size" {
  default = 8000
}
variable "num_cpu" {
  default = 1
}
variable "num_cores" {
  default = 1
}
variable "vm_ram" {
  default = 1096
}
variable "os_family" {
  default = ""
}
variable "os_iso_url" {
  default = ""
}