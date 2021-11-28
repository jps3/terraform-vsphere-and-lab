variable "vcenter_datacenter" {}
variable "vcenter_cluster" {}
variable "vcenter_datastore" {}
variable "vcenter_host" {}
variable "vs_insecure_connection" {}
variable "iso_datastore" {}
variable "iso_path" {}
variable "iso_checksum" {}
variable "vm_name" {}

resource "local_file" "pfsense_packer_auto_vars" {
  sensitive_content = <<-EOF
    vcenter_datacenter="${var.vcenter_datacenter}"
    vcenter_cluster="${var.vcenter_cluster}"
    vcenter_datastore="${var.vcenter_datastore}"
    vcenter_host="${var.vcenter_host}"
    vs_insecure_connection="${var.vs_insecure_connection}"
    iso_datastore="${var.iso_datastore}"
    iso_path="${var.iso_path}"
    iso_checksum="${var.iso_checksum}"
    vm_name="${var.vm_name}"
  EOF
  filename          = "${path.module}/packer/pfsense.auto.pkrvars.hcl"
  file_permission   = "0600"
}

#resource "null_resource" "packer_pfsense_build" {
#  provisioner "local-exec" {
#    command     = "packer build -on-error=cleanup ."
#    working_dir = "${path.module}/packer"
#    interpreter = ["/bin/bash", "-c"]
#  }
#  depends_on = [
#    local_file.pfsense_packer_auto_vars,
#  ]
#}