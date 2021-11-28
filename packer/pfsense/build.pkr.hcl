packer {
  required_plugins {
    vsphere = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

build {
  sources = [
    "source.vsphere-iso.pfsense"
  ]
  provisioner "shell-local" {
    inline = ["The build name is: $PACKER_BUILD_NAME"]
  }
}
