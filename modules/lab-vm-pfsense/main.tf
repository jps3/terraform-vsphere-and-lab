variable "vcenter_datacenter" {}
variable "vcenter_cluster" {}
variable "vcenter_datastore" {}
variable "vcenter_host" {}
variable "insecure_connection" {}
variable "iso_datastore" {}
variable "iso_path" {}
variable "iso_checksum" {}
variable "vm_name" {}

resource "null_resource" "packer_pfsense_build" {
  provisioner "local-exec" {
    environment = {
      PKR_VAR_vcenter_datacenter="${var.vcenter_datacenter}"
      PKR_VAR_vcenter_cluster="${var.vcenter_cluster}"
      PKR_VAR_vcenter_datastore="${var.vcenter_datastore}"
      PKR_VAR_vcenter_host="${var.vcenter_host}"
      PKR_VAR_insecure_connection="${var.insecure_connection}"
      PKR_VAR_iso_datastore="${var.iso_datastore}"
      PKR_VAR_iso_path="${var.iso_path}"
      PKR_VAR_iso_checksum="${var.iso_checksum}"
    }
    # TODO: If there's a failure this does not necessarily clean up!
    command = "packer build -on-error=cleanup ."
    working_dir = "${path.module}/packer"
    interpreter = ["/bin/bash","-c"]
  }
}